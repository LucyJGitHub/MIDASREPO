      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001416)                              *
      *                                                               *
      *  GLH00395 - Midas GL Retrieve Shadow Post. by Network Account *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     D                 DS                                                       UUC103
     D NARRAT                        30                                         UUC103
     D  SACNO                  6     15                                         UUC103
     D  @DTA                  24     24                                         UUC103
     D  BTNB                  25     27                                         UUC103
     D  BINB                  28     30  0                                      UUC103
     D  BINN                  28     30                                         UUC103
                                                                                UUC103
     D GLExtNarr       DS                                                       UUC103
      ** Data Structure used to concatenate the extended narratives             UUC103
     D   GLMGADI1                                                               UUC103
     D   GLMGADI2                                                               UUC103
     D   GLMGADI3                                                               UUC103
     D   GLMGADI4                                                               UUC103
     D   GLMGADI5                                                               UUC103
     D   GLMGADI6                                                               UUC103
