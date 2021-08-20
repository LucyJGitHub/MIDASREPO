      *****************************************************************
      *                                                               *
      *  LE0450C024 - LE0450 - File definition                        *
      *                                                               *
      *  Last Amend No. LUC125   *Create   Date 14Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC125 - Make profit center pass through from transaction    *
      *           (Upgrade pf A66108)                                 *
      *                                                               *
      *****************************************************************
      *                                                                                       LUC125
      **  If Profit Center Defaulting is active, determine                                    LUC125
      **   the Funding Profit Center                                                          LUC125
      *                                                                                       LUC125
     C     LUC125        Ifeq      'Y'                                                        LUC125
      *                                                                                       LUC125
     C     BKPCDU        Ifeq      'Y'                                                        LUC125
     C                   MoveL     LTYP          TRTPPR                                       LUC125
     C                   MoveL     SUTP          SUTPPR                                       LUC125
     C                   Movel     CNUML         CNUMPR                                       LUC125
      *                                                                                       LUC125
     C                   Call      'AOPRFMR0'                                                 LUC125
     C                   Parm      *Blanks       RTCDPR            1                          LUC125
     C                   Parm      BOKC          BOOKPR            2                          LUC125
     C                   Parm                    TRTPPR            5                          LUC125
     C                   Parm                    SUTPPR            2                          LUC125
     C                   Parm      BRCA          BRANPR            3                          LUC125
     C                   Parm      *Blanks       DEPTPR            3                          LUC125
     C                   Parm      *Blanks       USERPR           10                          LUC125
     C                   Parm      *Blanks       ACOFPR            2                          LUC125
     C                   Parm                    CNUMPR            6                          LUC125
     C                   Parm      *Blanks       PRFCPR            4                          LUC125
      *                                                                                       LUC125
     C     RTCDPR        Ifne      '0'                                                        LUC125
     C                   Move      PRFC          PRFCPR                                       LUC125
     C                   Endif                                                                LUC125
      *                                                                                       LUC125
     C                   Else                                                                 LUC125
     C                   Move      PRFC          PRFCPR                                       LUC125
     C                   Endif                                                                LUC125
      *                                                                                       LUC125
      **  If Profit Center Defaulting is active, determine the Book                           LUC125
      **  Code for the Account Officer Profit Center (i.e. not the                            LUC125
      **  Loan Book Code which points to the Funding area),                                   LUC125
      **  and swap them.                                                                      LUC125
     C     BKPCDU        Ifeq      'Y'                                                        LUC125
     C                   Move      BOKC          W@BOKC            2                          LUC125
      *                                                                                       LUC125
     C     PRFC          SetGt     XXPRFML1                                                   LUC125
     C     PRFC          ReadPe    XXPRFML1                               16                  LUC125
      *                                                                                       LUC125
      **  Continue until a valid entry or no more matches.                                    LUC125
     C     *IN16         Downe     *ON                                                        LUC125
      *                                                                                       LUC125
     C     DWBKCD        Ifne      '**'                                                       LUC125
     C     DWBKCD        andne     '  '                                                       LUC125
     C                   Move      DWBKCD        BOKC                                         LUC125
     C                   Leave                                                                LUC125
     C                   Endif                                                                LUC125
      *                                                                                       LUC125
     C     PRFC          READPE    XXPRFML1                               16                  LUC125
     C                   Enddo                                                                LUC125
     C                   Endif                                                                LUC125
      *                                                                                       LUC125
     C                   Endif                                                                LUC125
      *                                                                                       LUC125
      *****************************************************************                       LUC125
      * End of /COPY LE0450C024                                       *                       LUC125
      *****************************************************************                       LUC125
