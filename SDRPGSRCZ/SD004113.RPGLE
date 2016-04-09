     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD User Security Audit Extract - MCMPSDD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD004113 - Midas SD User Security Audit Extract - MCMPSDD    *
      *                                                               *
      *  Function:  Midas SD User Security Audit Extract - MCMPSDD    *
      *                                                               *
      *  Called By: CLLE/GP004113                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD022874           Date 15Oct13               *
      *  Prev Amend No. MD022606           Date 27Sep13               *
      *                 AR1059289 *CREATE  Date 23Nov12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022874 - Increase the size of MuNoRec from 4S to 7S.       *
      *  MD022606 - Increase the size of SgNoRec from 4S to 7S.       *
      *  AR1059289 - Global program compilation issues                *
      *            - Part of Security Model Audit Reporting           *
      *              (CBF022 - BF Infrastructure: Auditability)       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      * *PSSR  - Program exception error routine                      *
      * SrUpgrade - SR to extract data                                *
      * SrLVCMP - SR to extract data from left to right               *
      * SrRVCMP - SR to extract data from right to left               *
      * SrWrite - SR to write record to new file                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SF Valid Companies for User
     FMCMPS     UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SF Valid Companies for User - global
     FGPCMPSPD  UF A E           K DISK    RENAME(MCMPSDDF:MCMPSG)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SVALKK          C                   CONST('ZoneSystemName')
 
     D SVAL1           DS           200
     D  WSVAl1                 1     10
 
     D VCMPDS          DS           300
     D  LVCMPOS                1      3
     D  RVCMPOS              298    300
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D @RTCD           S              7
 
      ** Number of records read from MUSERDD
     D*MuNoRec**       S              4S 0                                                  MD022874
     D MuNoRec         S              7S 0                                                  MD022874
 
      ** Number of records written to GPCMPSPD
     D*SgNoRec**       S              4S 0                                                  MD022606
     D SgNoRec         S              7S 0                                                  MD022606
 
     D RecPos          S              4S 0
 
     D nPos            S              4S 0
     D nCount          S              4S 0
     D wVCMP           S              3
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
 
     C                   EVAL      MunoRec = 0
     C                   EVAL      RecPos = 1
 
      ** Extract Data
     C                   EXSR      SrUpgrade
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrUpgrade - SR to extract data                              *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: SrLVCMP, SrRVCMP, SrWrite                              *
      *                                                               *
      *****************************************************************
     C     SrUpgrade     BEGSR
 
     C                   EVAL      SgNoRec = 0
 
      ** Read all reacords in MCMPSDD
 
     C     *LOVAL        SETLL     MCMPS
     C                   READ      MCMPSDDF
 
     C                   DOW       NOT %EOF
     C                   EVAL      MunoRec = MunoRec + 1
 
     C                   EVAL      VCMPDS = VCMP
 
     C                   SELECT
     C     LVCMPOS       WHENNE    ' '
     C                   EXSR      SrLVCMP
     C     RVCMPOS       WHENNE    ' '
     C                   EXSR      SrRVCMP
     C                   OTHER
     C                   EVAL      wVCMP = ' '
     C                   EXSR      SrWrite
     C                   ENDSL
 
     C                   READ      MCMPSDDF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrLVCMP - SR to extract data from left to right             *
      *                                                               *
      * Called by: SrUpgrade                                          *
      *                                                               *
      * Calls: SrWrite                                                *
      *                                                               *
      *****************************************************************
     C     SrLVCMP       BEGSR
 
     C                   EVAL      nPos = 1
     C                   EVAL      nCount = 0
 
     C                   DOW       nCount <> NOOC
     C                   EVAL      wVCMP = ' '
     C                   EVAL      wVCMP = %SUBST(VCMP:nPos:3)
     C                   EVAL      nPos = nPos + 3
     C                   EVAL      nCount = nCount + 1
 
     C                   EXSR      SrWrite
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrRVCMP - SR to extract data from right to left             *
      *                                                               *
      * Called by: SrUpgrade                                          *
      *                                                               *
      * Calls: SrWrite                                                *
      *                                                               *
      *****************************************************************
     C     SrRVCMP       BEGSR
 
     C                   EVAL      nPos = 298
     C                   EVAL      nCount = 0
 
     C                   DOW       nCount <> NOOC
     C                   EVAL      wVCMP = ' '
     C                   EVAL      wVCMP = %SUBST(VCMP:nPos:3)
     C                   EVAL      nPos = nPos - 3
     C                   EVAL      nCount = nCount + 1
 
     C                   EXSR      SrWrite
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SrWrite - SR to write record to new file                    *
      *                                                               *
      * Called by: SrUpgrade, SrLVCMP, SrRVCMP                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWrite       BEGSR
 
      ** Insert Records to GPBRCOPD
 
     C                   EVAL      G_RECI = RECI
     C                   EVAL      G_USRP = USRP
     C                   EVAL      G_CMP = wVCMP
     C                   EVAL      G_LCD = LCD
     C                   EVAL      G_CHTP = CHTP
     C                   EVAL      G_LCT = LCT
     C                   EVAL      G_CPZONE = WSVAl1
 
      ** Add 1 to Record Count
 
     C                   EVAL      SgNoRec = SgNoRec + 1
     C                   WRITE     MCMPSG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   *INZSR - Program Initialisation Routine                     *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   EVAL      SgNoRec = 0
     C                   EVAL      MunoRec = 0
 
      ** Call AOSVALR0 to get the Zone
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK10          20
     C                   PARM                    SVAL10          200
 
      ** If the system value is not found then issue a Database Error
 
     C                   IF        @RTCD <> '*NRF' AND
     C                             @RTCD <> *BLANKS
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 990
     C                   EVAL      DBKey = SVALK1
 
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   *PSSR - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
