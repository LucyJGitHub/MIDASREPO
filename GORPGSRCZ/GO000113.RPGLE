     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - Accounts')            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000113 - Global Processing data dowload, Account Codes     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD027189           Date 29May14               *
      *  Prev Amend No. MD025737           Date 20May14               *
      *                 MD020167           Date 23Apr13               *
      *                 CCB020A            Date 06Aug12               *
      *                 CCB023             Date 06Aug12               *
      *                 263607             Date 17Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 252816             Date 21Feb08               *
      *                 245889  *CREATE    Date 15Mar07               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD027189 - Dashboard does not reflect the unauthorised       *
      *             Closed NOSTRO items in WIP                        *
      *  MD025737 - Amend of an account; waiting authorisation inside *
      *             the WIP; but not displayed on the Dasboard        *
      *           - Applied for MD-26968                              *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB020A - COB Restructure - Secondary COB Infrastructure     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  263607 - GL: Incomplete a/cs should not prevent COB start.   *
      *           Recompile due to changes in GPACWIPL                *
      *  252816 - issue USROPN to GPDWNLL0 to prevent creating dumps  *
      *           caused by opening a file which is already opened    *
      *  245889 - Include in Midas Plus Dashboard                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGPACWIPL  IF   E           K DISK    INFSR(*PSSR)
     FGPNOWIPL  IF   E           K DISK    INFSR(*PSSR)                                     MD025737
     FGPNCWIPL  IF   E           K DISK    INFSR(*PSSR)                                     MD027189
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                             252816
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5
      *
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D Value           S             50
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY GOCPYSRC,GOUPD_PARM
      *
      * Get Zone Name from system ID.
     C     System_ID     CHAIN     GPZONED0                           90
      *
      * Unauthorised Account Codes
     C                   IF        Key_Desc = 'UnauthAccounts'
      *
     C                   EXSR      UpdateCount
      *
     C                   ENDIF
      *
      * Unauthorised Nostro Account Codes                                                   MD025737
     C                   IF        Key_Desc = 'UnauthNostroAccounts'                        MD025737
      *                                                                                     MD025737
     C                   EXSR      UpdateCountN                                             MD025737
      *                                                                                     MD025737
     C                   ENDIF                                                              MD025737
      *                                                                                     MD025737
      * Unauthorised For Closure Nostro Account Codes                                       MD027189
     C                   IF        Key_Desc = 'UnauthCloseNostrAcct'                        MD027189
      *                                                                                     MD027189
     C                   EXSR      UpdateCountNC                                            MD027189
      *                                                                                     MD027189
     C                   ENDIF                                                              MD027189
      *                                                                                     MD027189
     C/COPY GOCPYSRC,GOUPD_DWNL
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateCount - This does the read of the file containing       *
      *               unauthorised account codes and updates the      *
      *               count accordingly.                              *
      *                                                               *
      * Called by: *MAIN                                              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     UpdateCount   BEGSR
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                         CCB020A
     C                   IF        MidasPhase = 'C'                                          CCB020A
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C     *LOVAL        SETLL     T@MSWIP
     C                   READ      T@MSWIP                                01
      *
     C                   DOW       *IN01 = *OFF
     C                   IF        MSWZONE = ZOZONE
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   READ      T@MSWIP                                01
     C                   ENDDO
      *
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C     UpdateCountE  ENDSR
      *
      /EJECT
      *****************************************************************                     MD025737
      *                                                               *                     MD025737
      * UpdateCountN - This does the read of the file containing      *                     MD025737
      *                unauthorised account codes and updates the     *                     MD025737
      *                count accordingly.                             *                     MD025737
      *                                                               *                     MD025737
      * Called by: *MAIN                                              *                     MD025737
      *                                                               *                     MD025737
      * Calls: None                                                   *                     MD025737
      *                                                               *                     MD025737
      *****************************************************************                     MD025737
      *                                                                                     MD025737
     C     UpdateCountN  BEGSR                                                              MD025737
      *                                                                                     MD025737
      * If the Midas phase is not Input Cycle then set data to blank.                       MD025737
     C                   IF        MidasPhase = 'C'                                         MD025737
     C                   EVAL      Value = *Blanks                                          MD025737
     C                   ELSE                                                               MD025737
      *                                                                                     MD025737
     C                   EVAL      CountN = 0                                               MD025737
      *                                                                                     MD025737
     C     *LOVAL        SETLL     T@NSWIP                                                  MD025737
     C                   READ      T@NSWIP                                01                MD025737
      *                                                                                     MD025737
     C                   DOW       *IN01 = *OFF                                             MD025737
     C                   IF        MSWZONE = ZOZONE                                         MD025737
     C                   EVAL      CountN = CountN + 1                                      MD025737
     C                   ENDIF                                                              MD025737
     C                   READ      T@NSWIP                                01                MD025737
     C                   ENDDO                                                              MD025737
      *                                                                                     MD025737
     C                   EVAL      Value = CountA                                           MD025737
      *                                                                                     MD025737
     C                   ENDIF                                                              MD025737
      *                                                                                     MD025737
     C                   ENDSR                                                              MD025737
      *                                                                                     MD025737
      /EJECT                                                                                MD025737
      *****************************************************************                     MD027189
      *                                                               *                     MD027189
      * UpdateCountNC - This does the read of the file containing     *                     MD027189
      *                 unauthorised nostro accounts for closure      *                     MD027189
      *                 and updates the count accordingly.            *                     MD027189
      *                                                               *                     MD027189
      * Called by: *MAIN                                              *                     MD027189
      *                                                               *                     MD027189
      * Calls: None                                                   *                     MD027189
      *                                                               *                     MD027189
      *****************************************************************                     MD027189
      *                                                                                     MD027189
     C     UpdateCountNC BEGSR                                                              MD027189
      *                                                                                     MD027189
      * If the Midas phase is not Input Cycle then set data to blank.                       MD027189
     C                   IF        MidasPhase = 'C'                                         MD027189
     C                   EVAL      Value = *Blanks                                          MD027189
     C                   ELSE                                                               MD027189
      *                                                                                     MD027189
     C                   EVAL      CountN  = 0                                              MD027189
      *                                                                                     MD027189
     C     *LOVAL        SETLL     T@NCWIP                                                  MD027189
     C                   READ      T@NCWIP                                02                MD027189
      *                                                                                     MD027189
     C                   DOW       *IN02 = *OFF                                             MD027189
     C                   IF        MSWZONE = ZOZONE                                         MD027189
     C                   EVAL      CountN  = CountN  + 1                                    MD027189
     C                   ENDIF                                                              MD027189
     C                   READ      T@NCWIP                                02                MD027189
     C                   ENDDO                                                              MD027189
      *                                                                                     MD027189
     C                   EVAL      Value = CountA                                           MD027189
      *                                                                                     MD027189
     C                   ENDIF                                                              MD027189
      *                                                                                     MD027189
     C                   ENDSR                                                              MD027189
      *                                                                                     MD027189
      /EJECT                                                                                MD027189
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
