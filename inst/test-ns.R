before <- loadedNamespaces()
library(helpr)
after <- loadedNamespaces()
print(diff_vecs(before, after))
