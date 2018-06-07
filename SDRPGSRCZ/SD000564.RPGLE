     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Authority Holder Indicia ')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000564 - Midas SD Authority Holder Indicia                 *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CGL157  *CREATE    Date 17Aug17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCRSDL1  UF A E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Authority Holder
     FSDCUAHL1  IF   E           K DISK

     FSDCRSDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HD:2)
     F                                     RENAME(SDCRSDD0:SDCRSDD2)

     FSDCRSNL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HN:2)
     F                                     RENAME(SDCRSND0:SDCRSND2)

      ** Midas Non-Account Holder Details File
     FSDNAHOL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(N0)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for CUSD
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for SVAL
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)

     DWDS              DS
     D ArAuHolder                    26A   DIM(50)
     D  ArAuCust                     10A   OVERLAY(ArAuHolder:1)
     D  ArLnkTyp                      2A   OVERLAY(ArAuHolder:11)
     D  ArPrdGrp1                     2A   OVERLAY(ArAuHolder:13)
     D  ArPrdGrp2                     2A   OVERLAY(ArAuHolder:15)
     D  ArPrdGrp3                     2A   OVERLAY(ArAuHolder:17)
     D  ArPrdGrp4                     2A   OVERLAY(ArAuHolder:19)
     D  ArAutType                     2A   OVERLAY(ArAuHolder:21)
     D  ArAuConInt                    1A   OVERLAY(ArAuHolder:23)
     D  ArAuConPrc                    3A   OVERLAY(ArAuHolder:24)

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D ArAuthCust      S             26A   DIM(50)
     D PCountry        S              2A   DIM(30)
     D PMember         S              6A   DIM(999)

     D KCust           S              6A
     D PRetcode        S              7A
     D POption         S              7A
     D Poptn           S              7A
     D PKey1           S             10A
     D PKySt           S              7A

      ** Timestamp for the transaction
     D TimeStamp       S               Z
     D WTime           S               T
     D WWTIME          S              6A
     D DDCUST          S              6A
     D WCTRY           S              2A

     D WREPT           S              1A
     D KCTRY           S              2A
     D KAUTC           S              6A
     D KAUTH           S             10A
     D KMEMB           S              6A
     D WREAD           S              1A
     D WCUST           S              6A
     D PReturn         S              7A
     D N               S              3S 0
     D WRUN            S              1
     D PIndFlag        S              1A
     D Ix              S              2S 0 INZ(0)
     D X               S              2S 0 INZ(0)


      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      KCUST = *Blanks
     C                   EVAL      KAUTH = *Blanks
     C                   EVAL      PIndFlag = ' '
     C                   EVAL      Pmember(1) = *Blanks

     C                   EVAL      Ix = 1
     C                   EVAL      X = 1
     C                   EVAL      ArAuHolder = *BLANKS
     C                   MOVEA     ArAuthCust    ArAuHolder

     C                   DOW       ArAuthCust(Ix) <> *BLANKS
     C                             AND Ix < 50

     C                   EVAL      Pmember(1) = WCUST
     C                   EVAL      CACUST = WCUST
     C                   EVAL      CAAUTH = ArAuCust(Ix)
     C                   EXSR      SrMltLvl2

     C                   EVAL      Ix = Ix + 1
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltLvl2 - Process multi level authority holder              *
      *                                                               *
      * Called by: SrMltLvl                                           *
      *                                                               *
      *****************************************************************

     C     SrMltLvl2     BEGSR

     C                   GOTO      FirstProc

     C     CReposition   TAG

     C     KCUAH         SETLL     SDCUAHL1
     C     NReposition   TAG
     C                   READ      SDCUAHL1

      ** Read another record
     C                   IF        WREAD = 'Y'
     C                   READ      SDCUAHL1
     C                   ENDIF
     C                   EVAL      WREAD = ' '

      ** End of End of File, quit
     C                   IF        %EOF(SDCUAHL1)
     C                   GOTO      END
     C                   ENDIF

     C                   IF        KCUST = CACUST

     C     FirstProc     TAG

     C                   EVAL      KCUST = CACUST
     C                   IF        CAAUTH <> *Blanks

      ** Check if Authority Holder is a Non-Account Holder
     C     CAAUTH        CHAIN     SDNAHOL0
     C                   IF        %FOUND(SDNAHOL0)

      ** NAHO authority Holder CRS details
     C     CAAUTH        SETLL     SDCRSNL2
     C     CAAUTH        READE     SDCRSNL2

     C                   DOW       NOT %EOF(SDCRSNL2)
     C                             AND CAAUTH = HNNAHO
     C                             AND X < 30
     C                   IF        HNREPT = 'Y'
     C                             AND %LOOKUP(HNCTRY:PCountry) = 0

     C                   EVAL      PIndFlag = 'Y'
     C                   EVAL      PCountry(X) = HNCTRY
     C                   EVAL      X = X + 1
     C                   ENDIF

     C     CAAUTH        READE     SDCRSNL2
     C                   ENDDO

     C                   EVAL      KCUST = CACUST
     C                   GOTO      NReposition

     C                   ELSE
      ** CUST Authority Holder CRS details
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      Pmember(n) = CAAUTH

     C                   EVAL      KAUTC = CAAUTH
     C     KAUTC         SETLL     SDCRSDL2
     C     KAUTC         READE     SDCRSDL2

     C                   DOW       NOT %EOF(SDCRSDL2)
     C                             AND CAAUTH = HDCUST
     C                             AND X < 30
     C                   IF        HDREPT = 'Y'
     C                             AND %LOOKUP(HDCTRY:PCountry) = 0

     C                   EVAL      PIndFlag = 'Y'
     C                   EVAL      PCountry(X) = HDCTRY
     C                   EVAL      X = X + 1
     C                   ENDIF

     C     KAUTC         READE     SDCRSDL2
     C                   ENDDO

     C                   EVAL      KCUST = CAAUTH
     C                   EVAL      KAUTH = *Blanks
     C                   ENDIF
     C                   ENDIF

     C                   ELSE
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   IF        n = 2
     C                   GOTO      END
     C                   ENDIF

     C                   EVAL      KCUST = Pmember(n-2)
     C                   EVAL      KAUTH = Pmember(n-1)
     C                   EVAL      Pmember(n-1) = *Blanks
     C                   EVAL      WREAD = 'Y'
     C                   ENDIF

     C                   GOTO      CReposition
     C     END           TAG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *DTAARA       DEFINE                  LDA

     C     *Entry        PLIST
     C                   PARM                    PReturn
     C                   PARM                    WCUST
     C                   PARM                    ArAuthCust
     C                   PARM                    PIndFlag
     C                   PARM                    PCountry

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     KCRD2         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KCTRY

     C     KCUAH         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KAUTH

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *Blanks
     C                   EVAL      WRUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

