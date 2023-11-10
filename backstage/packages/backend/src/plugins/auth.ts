import { createRouter, providers } from '@backstage/plugin-auth-backend';
import { Router } from 'express';
import { PluginEnvironment } from '../types';
import {
  stringifyEntityRef,
  DEFAULT_NAMESPACE,
} from '@backstage/catalog-model';

export default async function createPlugin(
  env: PluginEnvironment,
): Promise<Router> {
  return await createRouter({
    ...env,
    providerFactories: {
      // see https://backstage.io/docs/auth/identity-resolver#sign-in-without-users-in-the-catalog
      google: providers.google.create({
        signIn: {
          resolver: async ({ profile }, ctx) => {
            if (!profile.email) {
              throw new Error(
                'Login failed, user profile does not contain an email',
              );
            }
            // Split the email into the local part and the domain.
            const [localPart, domain] = profile.email.split('@');

            // Next we verify the email domain. It is recommended to include this
            // kind of check if you don't look up the user in an external service.
            if (domain !== 'gcp.hc-sc.gc.ca') {
              throw new Error(
                `Login failed, this email ${profile.email} does not belong to the expected domain`,
              );
            }

            // By using `stringifyEntityRef` we ensure that the reference is formatted correctly
            const userEntity = stringifyEntityRef({
              kind: 'User',
              name: localPart,
              namespace: DEFAULT_NAMESPACE,
            });
            return ctx.issueToken({
              claims: {
                sub: userEntity,
                ent: [userEntity],
              },
            });
          },
        },
      }),
    },
  });
}
