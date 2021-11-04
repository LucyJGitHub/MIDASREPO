      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00422 - Midas GL Format Posting details                   *
      *                                                               *
      *  Last Amend No. UUC061 *Create  Date 06Sep11                  *
      *  Prev Amend No. 237855          Date 06Sep11                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC061 - Upgrade of CAR UUC052 from M+ to BF-Midas           *
      *           UUC052 - SWIFT Statement Enhancement                *
      *           Following Fixes to be upgraded as part of UUC061:   *
      *              237855 - Same coding as '225765' in GL1300 needed*
      *                      in GL001432                              *
      *                      (avoid invalid transaction code for FT)  *
      *                                                               *
      *****************************************************************
     C                   ELSE                                                   UUC103
     C                   MOVEL     GLOTTP        WTYPE             2            UUC103
     C                   CLEAR                   W0ACT                          UUC103
     C                   MOVEL     WTYPE         W0ACT                          UUC103
     C                   ENDIF                                                  UUC103
