// ============== //
//   Parameters   //
// ============== //

import { serviceGroupTargetResourceIdsType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The resource IDs of the service groups you wish to associate this resource with.')
param serviceGroupTargetResourceIds serviceGroupTargetResourceIdsType[]?

// ============= //
//   Resources   //
// ============= //

resource serviceGroup_Members 'Microsoft.Relationships/serviceGroupMember@2023-09-01-preview' = [for serviceGroupResourceId in (serviceGroupTargetResourceIds ?? []): {
  name: uniqueString(>singularMainResourceType<.id, serviceGroupResourceId)
  properties: {
    targetId: serviceGroupResourceId
  }
  scope: >singularMainResourceType<
}]
