     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Generate Country of Tax Defaults')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCTTXDFLT - Midas SD Generate Country of Tax Defaults       *
      *                                                               *
      *  Function:  This program will automatically generate          *
      *             non-taxable Country of Tax defaults for Midas     *
      *             systems running with CGL031 - Taxation of         *
      *             Savings Income (EU Tax). It should be run         *
      *             only if                                           *
      *             1. CGL031 & CGL032 are both on.                   *
      *             2. Location Codes have been defined for every     *
      *                branch in SDBRCHPD.                            *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10767 *CREATE   Date 15Mar06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG10767 - Midas SD Generate Country of Tax Defaults         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Country of Tax Codes - Retrieve Index
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCTTXD0:SDCTTXD1)
 
      ** Midas SD Country of Tax Codes
     FSDCTTXPD  O    E             DISK    INFSR(*PSSR)
 
      ** Midas SD Branch Codes - Retrieve Index
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Standing Data Controls - Update Index
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@AHREAU:SDFCTLD0)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Local Data Area Details Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Location Code Details Data Structure
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** Country of Tax Code Details Data Structure
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PLocn           S              3A
 
      ** Key Fields
     D KCtrT           S                   LIKE(EWCTRT)
     D KCtrR           S                   LIKE(EWCTRR)
     D KFLNM           S                   LIKE(AHFLNM)
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1
 
     C                   DOW       NOT %EOF
 
      ** Get Location details.
 
     C                   EVAL      PLocn = A8LCCD
     C                   EXSR      SRGetLocn
 
      ** Write a (non-taxable) Country of Tax if no record is found.
 
     C                   EVAL      KCtrT = DVCNCD
     C                   EVAL      KCtrR = *BLANKS
     C     KCTTX         CHAIN     SDCTTXL1
 
     C                   IF        NOT %FOUND
     C                   EXSR      SRWrtCtrT
     C                   ENDIF
 
     C                   READ      SDBRCHL1
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetLocn - Gets Location details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetLocn     BEGSR
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PLocn
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDLOCNPD'
     C                   EVAL      DBKey = PLocn
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrtCtrT - Writes a (non-taxable) Country of Tax.           *
      *                                                               *
      *****************************************************************
     C     SRWrtCtrT     BEGSR
 
     C                   CLEAR                   SDCTTX
 
     C                   EVAL      EWCTRT = DVCNCD
     C                   EVAL      EWTXS1 = 'E'
     C                   EVAL      EWEDT1 = BJRDNB
     C                   EVAL      EWTRT1 = '2'
     C                   EVAL      EWCHTP = 'I'
     C                   EVAL      EWLCDT = BJRDNB
     C                   EVAL      EWDMAP = 'N'
     C                   EVAL      EWTXCB = 'S'
     C                   EVAL      EWPADD = 'N'
     C                   EVAL      EWTIST = 'N'
 
     C                   WRITE     SDCTTXD0
 
      ** Update Standing Data Controls.
 
     C                   EVAL      KFLNM = 'SDCTTXPD'
     C     KFLNM         CHAIN     SDFCTLL0
 
     C                   IF        %FOUND
     C                   EVAL      AHNORC = AHNORC + 1
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   UPDATE    SDFCTLD0
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBKey = KFLNM
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key Lists
 
     C     KCTTX         KLIST
     C                   KFLD                    KCtrT
     C                   KFLD                    KCtrR
 
      ** Get Bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2006
