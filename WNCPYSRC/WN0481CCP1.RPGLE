      *****************************************************************                       EML110
      *                                                               *                       EML110
      *  Midas - SD0021E - Copy member (RPGLE)                        *                       EML110
      *                                                               *                       EML110
      *  WN0481CCP1 - SD0021E                                         *                       EML110
      *                                                               *                       EML110
      *  Last Amend No. MD061301           Date 19Apr23               *                     MD061301
      *  Prev Amend No. EML110   *CREATE   Date 20Jan20               *                       EML110
      *                                                               *                       EML110
      *---------------------------------------------------------------*                       EML110
      *                                                               *                       EML110
      *  MD061301 - Change of type on EML110 copy sources from        *                     MD061301
      *             RPG to RPGLE.                                     *                     MD061301
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *                       EML110
      *                                                               *                       EML110
      *****************************************************************                       EML110
      *                                                                                       EML110
     C     EML110        IFEQ      'Y'                                                        EML110
     C                   CALL      'XX0021W0'                                                 EML110
     C                   PARM      'E'           UACTCD            1            Action        EML110
     C                   PARM                    DATA                           Trans Data    EML110
     C                   PARM      *BLANK        W0RTN             7            Return Code   EML110
     C                   PARM      8             WLEN              3 0                        EML110
     C                   PARM      35            WWID              3 0                        EML110
     C                   PARM      11            SROW              3 0                        EML110
     C                   PARM      30            SCOL              3 0                        EML110
     C                   PARM      'XXX1093'     TITLE             7                          EML110
     C                   PARM                    SPARE           256                          EML110
     C                   ELSE                                                                 EML110
      *                                                                                       EML110
      *****************************************************************                       EML110
      * End of /COPY WN0481CCP1                                       *                       EML110
      *****************************************************************                       EML110
