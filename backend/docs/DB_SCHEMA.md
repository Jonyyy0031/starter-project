# Article Schema

Collection: articles

Document:
- id: string (docId)
- title: string (required)
- description: string
- content: string (required)
- author: string
- thumbnailURL: string
  - Reference to Firebase Storage: media/articles/{articleId}/thumbnail
- createdAt: timestamp
- updatedAt: timestamp
- isPublished: boolean
- tags: array<string>
- category: string
