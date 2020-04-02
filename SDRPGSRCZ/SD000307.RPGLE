     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Indicia Search Tool - Processing')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000307 - Midas SD CRS Indicia Search Tool - Processing     *
      *                                                               *
      *  Function:  This module checks for CRS Indicia for Customers  *
      *             and Non Account Holders.                          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD054605           Date 17Oct19               *
      *                 MD039670           Date 26Jul16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *           Applied for MD-55510.                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCCLSL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCTRYL5  IF   E           K DISK    INFSR(*PSSR)

     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CU:2)

     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)

     FSDNOSTL2  IF   E           K DISK    INFSR(*PSSR)

     FOTPAYL9   IF   E           K DISK    INFSR(*PSSR)

     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C1:2)
     F                                     RENAME(SDCRSHD0:SDCRSHD1)

     FSDCRNHL0  IF   E           K DISK    INFSR(*PSSR)

     FSDCRNHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(N1:2)
     F                                     RENAME(SDCRNHD0:SDCRNHD1)

     FSDCRSDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JC:2)
     F                                     RENAME(SDCRSDD0:SDCRSDD1)

     FSDCRSNL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JN:2)
     F                                     RENAME(SDCRSND0:SDCRSND1)

     FSDCRSDL1  UF A E           K DISK    INFSR(*PSSR)

     FSDCRSNL1  UF A E           K DISK    INFSR(*PSSR)

     FSDCRDFL1  UF A E           K DISK    INFSR(*PSSR)

     FSDCRNFL1  UF A E           K DISK    INFSR(*PSSR)

      ** Midas SD Joint Account Member
     FSDJACCL1  IF   E           K DISK

     FSDJACCL2  IF   E           K DISK
     F                                     PREFIX(JS:2)
     F                                     RENAME(SDJACCD0:SDJACCD1)

     FSDCRSDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JQ:2)
     F                                     RENAME(SDCRSDD0:SDCRSDD2)

     FSDCRSNL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(JR:2)
     F                                     RENAME(SDCRSND0:SDCRSND2)

      ** Midas SD Authority Holder
     FSDCUAHL1  IF   E           K DISK

     FSDCUAHL0  IF   E           K DISK
     F                                     PREFIX(C2:2)
     F                                     RENAME(SDCUAHD0:SDCUAHDX)

      ** Midas Non-Account Holder Details File
     FSDNAHOL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(N0)
     F                                     RENAME(SDNAHOD0:SDNAHON0)
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** Input/Output: Transaction ID
     DPReturn          S              7A
      ** Input: Transaction ID
     DPTranID          S             10A
      ** Input: Identify if Customer/NAHO/Joint
     DPSource          S              1A
      ** Input: Classification codes
     DPClasIF          S              5A
     DPClasNF          S              5A
      ** Input: Manual or Automatic Mode
     DPMode            S              1A
      ** Input: Reporting Type
     DPRepType         S              1A

     DArrayMax         C                   CONST(999)
     DIndiciaCount     C                   CONST(11)
     DSYSVAL1          C                    'FATCAEffectStartDate'
     DRepComment       C                    'Updated by US Indicia+
     D                                      Search Electronic Tool'
     DIndiciaF         S              1
     DIndToNo          S              1
     DWupdat           S              1
     D PCountry        S              2A   DIM(30)
     D PCtry1          S              4A   DIM(999)
     D PCtry2          S              2A   DIM(999)
     D PCrsa1          S              1A   DIM(999)
     D PCrsa2          S              1A   DIM(999)
     D PMember         S              6A   DIM(999)
     D PTypoDS         S              1A   DIM(5)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Run-time Array for Country Codes with FATCA Flag
     DCtryCodeArr      S              2    DIM(ArrayMax)

      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Second DS for Access Programs, Long Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for Access Programs, Long Data Structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for ACUS
     D SDCUXC        E DS                  EXTNAME(SDCUSTXC)

      ** External data structure for ACUS
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** External data structure for ALTN
     D SDALTN        E DS                  EXTNAME(SDALTNPD)

      ** External data structure for SARD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External data structure for FTNH
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
     D                                     PREFIX(HC:2)

      ** External data structure for CUSD
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for NAHO
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** External data structure for SVAL
     D*SDSVAL***     E DS                  EXTNAME(SDSVALPD)                                MD054605

      ** External data structure for SVAL
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** External data structure for SVAL
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)
      *
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)
      *
     D SDCRSDA       E DS                  EXTNAME(SDCRSDPD)
     D                                     PREFIX(R1:2)
      *
     D SDCRSDB       E DS                  EXTNAME(SDCRSDPD)
     D                                     PREFIX(R2:2)

      ** Data Structure for Joint Account member search
     D WJointAcChk     DS                  DIM(ArrayMax) QUALIFIED
     D  JointAc                       6A
     D  MemCount                      3S 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D Index           S              3S 0 INZ(1)
     D KCNUM           S              6A
     D KCust           S              6A
     D KCAUT           S              6A
     D KNAHO           S             10A
     D KAUTC           S              6A
     D KAUTH           S             10A


     D CSE023          S              1A
     D CSE024          S              1A
     D CSD092          S              1A

     D PRetcode        S              7A
     D POption         S              7A
     D PSARD           S              6A

     D WMesLen         S             15S 5 INZ(50)

     D PRTCD           S             20A   INZ(*BLANKS)
     D POP01           S             20A   INZ(*BLANKS)
     D PVL01           S            200A   INZ(*BLANKS)
     D POP02           S             20A   INZ(*BLANKS)
     D PVL02           S            200A   INZ(*BLANKS)
     D PKey1           S             10A
     D PKySt           S              7A

     D PDateFormat     S              1A
     D WEffDate        S              5P 0
     D WNEffDate       S              6P 0

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D WHasIndicia     S              1A   INZ('N')
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D WTime           S               T
     D WWTIME          S              6A
     D KUS             S              2A

      ** Joint Account DS Index
     D JIdx            S              2S 0 INZ(0)
     D MCount          S              3S 0 INZ(0)
     D WLoopCnt        S              3S 0 INZ(0)
     D WKey            S              6A

      ** OTPAY Key
     D KOTPAYType      S              1A
     D KOTPAYKey35     S             35A
     D KCUST35         S              6A

     D DDCDOM          S              1A
     D DDCRSA          S              1A
     D DDCUST          S              6A
     D DDJACM          S              1A
     D DDMAIL          S              1A
     D DDNAHO          S             10A
     D DDPHON          S              1A
     D DDREGP          S              1A
     D DDAUHO          S              1A
     D DDTINN          S              1A
     D DDTINI          S              1A
     D DDTINO          S              1A
     D X               S              2S 0
     D Y               S              1S 0
     D WCOLC           S              2A
     D WCTRY           S              2A
     D WPCTRR          S              2A
     D WPCTRT          S              2A
     D WREPT           S              1A
     D WWREPT          S              1A
     D WIndicia        S              1A
     D KCTRY           S              2A
     D OPCOLC          S              2A
     D PCUSTNO         S              6A
     D POPTN           S              7A
     D PTYPE           S              1A
     D KCType          S              1A
     D PTYPO           S              5A
     D WTypeI          S              1S 0
     D PNAHO           S             10A
     D WWFIND          S              4A
     D M               S              3S 0
     D N               S              3S 0
     D O               S              3S 0
     D P               S              3S 0
     D Q               S              3S 0
     D KJANO           S              6A
     D KMEMB           S              6A
     D KMEMN           S             10A
     D W1ST            S              1A
     D WREAD           S              1A
     D WFOUND          S              1A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A
     D PAftFTCS        S           5000A
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A
     D PAftCUAH        S           5000A
     D PBefCUXC        S           5000A
     D PAftCUXC        S           5000A
     D PBefCRSH        S           5000A
     D PAftCRSH        S           5000A
     D PBefCRSD        S           5000A
     D PAftCRSD        S           5000A
     D PACRV           S              1A
     D PELEC           S              1A
     D PCustN2         S              6A
     D A               S              4S 0

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
      * MAIN PROCEDURE                                                *
      *****************************************************************


     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   EVAL      PMode = 'M'
     C                   EVAL      PReturn = *BLANKS
     C                   EVAL      PTYPO = *Blanks
     C                   EVAL      O = 1
     C                   EVAL      P = 1
     C                   EVAL      Y = 1
     C                   EVAL      PCtry1 = *Blanks
     C                   EVAL      PCtry2 = *Blanks
     C                   EVAL      PCrsa1 = *Blanks
     C                   EVAL      PCrsa2 = *Blanks
     C                   EVAL      WTypeI = 1

     C     *LOVAL        SETLL     SDCCLSL0
     C                   READ(N)   SDCCLSL0

     C                   DOW       NOT %EOF(SDCCLSL0)

      ** Identify all Classification Code changes
     C                   IF        DPFCTP = '*'

     C                   EVAL      PTYPO = 'FNOPJ'

     C                   DOW       WTypeI < 6
     C                   EVAL      KCType = %SUBST(PTYPO:WTypeI:1)
     C                   EVAL      PTYPE = %SUBST(PTYPO:WTypeI:1)
     C                   EXSR      SRProcCUSD
     C                   EXSR      SRProcNAHO
     C                   EVAL      WTypeI = WTypeI + 1
     C                   ENDDO

     C                   ELSE

     C                   EVAL      KCType = DPFCTP
     C                   EVAL      PTYPE = DPFCTP
     C                   EVAL      %SUBST(PTYPO:Y:1) = PTYPE
     C                   EVAL      Y = Y + 1

     C                   EXSR      SRProcCUSD
     C                   EXSR      SRProcNAHO

     C                   ENDIF

     C                   READ(N)   SDCCLSL0
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcCUSD  - Process Non-Account Holders' Indicia            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrProcCUSD    BEGSR

     C     *LOVAL        SETLL     SDCRSHL0
     C                   READ      SDCRSHL0

     C                   DOW       NOT %EOF(SDCRSHL0)
     C                   IF        (CRTYPE = PTYPE)
     C                             AND (CRINFO = ' '
     C                             OR CRINFO = 'N')

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      CRCUST        Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   EVAL      DDCUST = CRCUST
     C                   EVAL      KCUST = DDCUST
     C                   EVAL      KCTRY = *Blanks
     C                   EVAL      A = 1
     C                   EVAL      PBefCRSD = *Blanks
     C                   EVAL      PAftCRSD = *Blanks
     C     KCRD2         SETLL     SDCRSDL1
     C                   READ      SDCRSDL1

     C                   DOW       NOT %EOF(SDCRSDL1)
     C                             AND CRCUST = CDCUST
     C                   EVAL      SDCRSDB = SDCRSD
     C                   EVAL      DDCUST= CDCUST
     C                   EVAL      WCTRY = CDCTRY
     C                   EVAL      WCOLC = BBCOLC
     C                   EVAL      WWREPT = ' '
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtryD
     C                   EXSR      SrChkPhnMail
     C                   EXSR      SRRegPayInst
     C                   EXSR      SrChkTIN

     C                   EVAL      WWREPT = CDREPT
     C                   IF        DDCDOM = 'Y'
     C                             OR DDMAIL = 'Y'
     C                             OR DDPHON = 'Y'
     C                             OR DDREGP = 'Y'
     C                             OR DDTINI = 'Y'
     C                             OR DDAUHO = 'Y'

     C                   IF        CDREPT = ' '
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDCDOM <> CDCODO
     C                             OR DDMAIL <> CDMAIL
     C                             OR DDPHON <> CDPHON
     C                             OR DDREGP <> CDRPAY
     C                             OR WWREPT <> CDREPT
     C                             OR DDTINN <> CDTINS
     C                             OR DDAUHO <> CDAUHO
     C                   EVAL      CDCODO = DDCDOM
     C                   EVAL      CDMAIL = DDMAIL
     C                   EVAL      CDPHON = DDPHON
     C                   EVAL      CDRPAY = DDREGP
     C                   EVAL      CDTINS = DDTINN
     C                   EVAL      CDAUHO = DDAUHO
     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   IF        SDCRSDB <> SDCRSDA
     C                   EVAL      %SUBST(PBefCRSD:A:218) = SDCRSDB
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   ENDIF
     C                   UPDATE    SDCRSDD0
     C                   ENDIF

     C                   READ      SDCRSDL1

     C                   ENDDO

     C                   EXSR      SrCustInd
     C                   ENDIF

      ** Write to the History of Customer Information
     C                   IF        CSD092 = 'Y'

     C                   CALL      'SD009696'
     C                   PARM      CRCUST        PCustN2
     C                   PARM      *BLANKS       PBefCUST
     C                   PARM      *BLANKS       PAftCUST
     C                   PARM      *BLANKS       PBefACUS
     C                   PARM      *BLANKS       PAftACUS
     C                   PARM      *BLANKS       PBefFTCS
     C                   PARM      *BLANKS       PAftFTCS
     C                   PARM      *BLANKS       PBefJACC
     C                   PARM      *BLANKS       PAftJACC
     C                   PARM      *BLANKS       PBefCUAH
     C                   PARM      *BLANKS       PAftCUAH
     C                   PARM      *BLANKS       PBefCUXC
     C                   PARM      *BLANKS       PAftCUXC
     C                   PARM      *BLANKS       PACRV
     C                   PARM      'Y'           PELEC
     C                   PARM      *BLANKS       PBefCRSH
     C                   PARM      *BLANKS       PAftCRSH
     C                   PARM                    PBefCRSD
     C                   PARM                    PAftCRSD
     C                   ENDIF

     C                   READ      SDCRSHL0
     C                   ENDDO

     C                   EXSR      SrMltLvl
     C                   EXSR      SrAutLvl

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCustInd  - Process Non-Account Holders' Indicia             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCustInd     BEGSR

      ** Process country of domicile

     C                   EVAL      KCTRY = BBCOLC
     C                   EVAL      KCUST = BBCUST
     C                   EVAL      DDREGP = ' '
     C     KCRD2         CHAIN     SDCRSDL0
     C                   IF        NOT %FOUND(SDCRSDL0)
     C                   EVAL      DDCUST= BBCUST
     C                   EVAL      WCTRY = BBCOLC
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkPhnMail
     C                   EXSR      SRRegPayInst
     C                   EXSR      SrChkTIN

     C                   EVAL      CDCUST = BBCUST
     C                   EVAL      CDCTRY = BBCOLC
     C                   EVAL      CDCODO = 'Y'
     C                   EVAL      CDMAIL = DDMAIL
     C                   EVAL      CDPHON = DDPHON
     C                   EVAL      CDRPAY = DDREGP
     C                   EVAL      CDTINS = DDTINN
     C                   EVAL      CDAUHO = DDAUHO
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks

     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   EVAL      %SUBST(PBefCRSD:A:218) = *Blanks
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   WRITE     SDCRSDD0
     C                   ENDIF

      ** Process mailing countries

     C                   EVAL      KCTRY = E5CTR1
     C                   EXSR      SrChkMailC

      ** Mailing country 2

     C                   EVAL      KCTRY = E5CTR2
     C                   EXSR      SrChkMailC

      ** Mailing country 3

     C                   EVAL      KCTRY = E5CTR3
     C                   EXSR      SrChkMailC

      ** Mailing country 4

     C                   EVAL      KCTRY = E5CTR4
     C                   EXSR      SrChkMailC

      ** Mailing country 5

     C                   EVAL      KCTRY = E5CTR5
     C                   EXSR      SrChkMailC

      ** Process phone number countries

     C                   EVAL      KCTRY = E5PHN1
     C                   EXSR      SrChkPhoneC

      ** Phone number country 2

     C                   EVAL      KCTRY = E5PHN2
     C                   EXSR      SrChkPhoneC

      ** Phone number country 3

     C                   EVAL      KCTRY = E5PHN3
     C                   EXSR      SrChkPhoneC

      ** Phone number country 4

     C                   EVAL      KCTRY = E5PHN4
     C                   EXSR      SrChkPhoneC

      ** Phone number country 5

     C                   EVAL      KCTRY = E5PHN5
     C                   EXSR      SrChkPhoneC

      ** Regular Payments
     C                   EXSR      SrCheckREGP

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcNAHO  - Process Non-Account Holders' Indicia            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrProcNAHO    BEGSR

     C                   EVAL      DDREGP = ' '
     C     *LOVAL        SETLL     SDCRNHL0
     C                   READ      SDCRNHL0

     C                   DOW       NOT %EOF(SDCRNHL0)

     C                   IF        (NRTYPE = PTYPE)
     C                             AND (NRINFO = ' '
     C                             OR NRINFO = 'N')
                                                                                            MD039670
     C                   EVAL      PKEY1 = NRNAHO                                           MD039670
     C                   IF        PKEY1 <> *BLANKS                                         MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *BLANKS       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PKEY1                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNHL0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD039670

     C     NRNAHO        CHAIN     SDNAHOL1

     C                   EVAL      KNAHO = NHNAHO
     C                   EVAL      KCTRY = *Blanks
     C     KCRN2         SETLL     SDCRSNL1
     C                   READ      SDCRSNL1

     C                   DOW       NOT %EOF(SDCRSNL1)
     C                             AND CNNAHO = NHNAHO
     C                   EVAL      WCOLC = NHCOLC
     C                   EVAL      WCTRY = CNCTRY
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtrDN
     C                   EXSR      SrChkPhnMalN
     C                   EXSR      SrChkTNN

     C                   EVAL      WWREPT = CNREPT
     C                   IF        DDCDOM = 'Y'
     C                             OR DDMAIL = 'Y'
     C                             OR DDPHON = 'Y'
     C                             OR DDTINN = 'Y'

     C                   IF        CNREPT = ' '
     C                   EVAL      CNREPT = 'Y'
     C                   EVAL      CNREPR = *Blanks
     C                   EVAL      CNREPD = BJRDNB

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME
     C                   EVAL      CNREPM = WWTIME
     C                   EVAL      CNREPU = PSUSER
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDCDOM <> CNCODO
     C                             OR DDMAIL <> CNMAIL
     C                             OR DDPHON <> CNPHON
     C                             OR WWREPT <> CNREPT
     C                   EVAL      CNCODO = DDCDOM
     C                   EVAL      CNMAIL = DDMAIL
     C                   EVAL      CNPHON = DDPHON
     C                   EXSR      SrWrtRptN
     C                   UPDATE    SDCRSND0
     C                   ENDIF

     C                   READ      SDCRSNL1
     C                   ENDDO

     C                   EXSR      SrNahoInd
     C                   ENDIF

     C                   READ      SDCRNHL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNahoInd  - Process Non-Account Holders' Indicia             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrNahoInd     BEGSR

      ** Process country of domicile

     C                   EVAL      KCTRY = NHCOLC
     C                   EVAL      KNAHO = NHNAHO
     C     KCRN2         CHAIN     SDCRSNL0
     C                   IF        NOT %FOUND(SDCRSNL0)
     C                   EVAL      DDNAHO = NHNAHO
     C                   EVAL      WCTRY = NHCOLC
     C                   EVAL      WCOLC = NHCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtrDN
     C                   EXSR      SrChkPhnMalN
     C                   EXSR      SrChkTNN

     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = NHCOLC
     C                   EVAL      CNCODO = 'Y'
     C                   EVAL      CNMAIL = DDMAIL
     C                   EVAL      CNPHON = DDPHON
     C                   EVAL      CNRPAY = DDREGP
     C                   EVAL      CNREPT = 'Y'
     C                   EVAL      CNREPR = *Blanks
     C                   EVAL      CNREPD = BJRDNB

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME
     C                   EVAL      CNREPM = WWTIME
     C                   EVAL      CNREPU = PSUSER
     C                   EXSR      SrWrtRptN
     C                   WRITE     SDCRSND0
     C                   ENDIF

      ** Process mailing countries

     C                   EVAL      KCTRY = NHMCT1
     C                   EXSR      SrChkMailN

      ** Mailing country 2

     C                   EVAL      KCTRY = NHMCT2
     C                   EXSR      SrChkMailN

      ** Mailing country 3

     C                   EVAL      KCTRY = NHMCT3
     C                   EXSR      SrChkMailN

      ** Mailing country 4

     C                   EVAL      KCTRY = NHMCT4
     C                   EXSR      SrChkMailN

      ** Mailing country 5

     C                   EVAL      KCTRY = NHMCT5
     C                   EXSR      SrChkMailN

      ** Process phone number countries

     C                   EVAL      KCTRY = NHPCT1
     C                   EXSR      SrChkPhoneN

      ** Phone number country 2

     C                   EVAL      KCTRY = NHPCT2
     C                   EXSR      SrChkPhoneN

      ** Phone number country 3

     C                   EVAL      KCTRY = NHPCT3
     C                   EXSR      SrChkPhoneN

      ** Phone number country 4

     C                   EVAL      KCTRY = NHPCT4
     C                   EXSR      SrChkPhoneN

      ** Phone number country 5

     C                   EVAL      KCTRY = NHPCT5
     C                   EXSR      SrChkPhoneN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkMailC - Check for mailing country indicia                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkMailC    BEGSR

     C                   IF        KCTRY <> *Blanks
     C                   EVAL      KCUST = BBCUST
     C     KCRD2         CHAIN     SDCRSDL0
     C                   IF        NOT %FOUND(SDCRSDL0)
     C                   EVAL      DDCUST= BBCUST
     C                   EVAL      WCTRY = KCTRY
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtryD
     C                   EXSR      SrChkPhnMail
     C                   EXSR      SRRegPayInst
     C                   EXSR      SrChkTIN

     C                   EVAL      CDCUST = BBCUST
     C                   EVAL      CDCTRY = KCTRY
     C                   EVAL      CDCODO = DDCDOM
     C                   EVAL      CDMAIL = 'Y'
     C                   EVAL      CDPHON = DDPHON
     C                   EVAL      CDRPAY = DDREGP
     C                   EVAL      CDTINS = DDTINN
     C                   EVAL      CDAUHO = DDAUHO
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks

     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   EVAL      %SUBST(PBefCRSD:A:218) = *Blanks
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   WRITE     SDCRSDD0
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkPhoneC - Check for phone number country indicia          *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkPhoneC   BEGSR

     C                   IF        KCTRY <> *Blanks
     C                   EVAL      KCUST = BBCUST
     C     KCRD2         CHAIN     SDCRSDL0
     C                   IF        NOT %FOUND(SDCRSDL0)
     C                   EVAL      DDCUST= BBCUST
     C                   EVAL      WCTRY = KCTRY
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtryD
     C                   EXSR      SrChkPhnMail
     C                   EXSR      SRRegPayInst
     C                   EXSR      SrChkTIN

     C                   EVAL      CDCUST = BBCUST
     C                   EVAL      CDCTRY = KCTRY
     C                   EVAL      CDCODO = DDCDOM
     C                   EVAL      CDMAIL = DDMAIL
     C                   EVAL      CDPHON = 'Y'
     C                   EVAL      CDRPAY = DDREGP
     C                   EVAL      CDTINS = DDTINN
     C                   EVAL      CDAUHO = DDAUHO
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks

     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   EVAL      %SUBST(PBefCRSD:A:218) = *Blanks
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   WRITE     SDCRSDD0
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkMailN - Check for mailing country indicia                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkMailN    BEGSR

     C                   IF        KCTRY <> *Blanks
     C                   EVAL      KNAHO = NHNAHO
     C     KCRN2         CHAIN     SDCRSNL0
     C                   IF        NOT %FOUND(SDCRSNL0)
     C                   EVAL      DDNAHO = NHNAHO
     C                   EVAL      WCTRY = KCTRY
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtrDN
     C                   EXSR      SrChkPhnMalN
     C                   EXSR      SrChkTNN

     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = KCTRY
     C                   EVAL      CNCODO = DDCDOM
     C                   EVAL      CNMAIL = DDMAIL
     C                   EVAL      CNPHON = DDPHON
     C                   EVAL      CNRPAY = DDREGP
     C                   EVAL      CNREPT = 'Y'
     C                   EVAL      CNREPR = *Blanks
     C                   EVAL      CNREPD = BJRDNB

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME
     C                   EVAL      CNREPM = WWTIME
     C                   EVAL      CNREPU = PSUSER
     C                   EXSR      SrWrtRptN
     C                   WRITE     SDCRSND0

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkPhoneN - Check for phone number country indicia          *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkPhoneN   BEGSR

     C                   IF        KCTRY <> *Blanks
     C                   EVAL      KNAHO = NHNAHO
     C     KCRN2         CHAIN     SDCRSNL0
     C                   IF        NOT %FOUND(SDCRSNL0)
     C                   EVAL      DDNAHO = NHNAHO
     C                   EVAL      WCTRY = KCTRY
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkCtrDN
     C                   EXSR      SrChkPhnMalN
     C                   EXSR      SrChkTNN

     C                   EVAL      CNNAHO = NHNAHO
     C                   EVAL      CNCTRY = KCTRY
     C                   EVAL      CNCODO = DDCDOM
     C                   EVAL      CNMAIL = DDMAIL
     C                   EVAL      CNPHON = DDPHON
     C                   EVAL      CNRPAY = DDREGP
     C                   EVAL      CNREPT = 'Y'
     C                   EVAL      CNREPR = *Blanks
     C                   EVAL      CNREPD = BJRDNB

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     WTime
     C     *HMS0         MOVE      WTime         WWTIME
     C                   EVAL      CNREPM = WWTIME
     C                   EVAL      CNREPU = PSUSER
     C                   EXSR      SrWrtRptN
     C                   WRITE     SDCRSND0

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkCtryD  - Check for country of domicile indicia           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkCtryD    BEGSR

     C                   EVAL      DDCDOM = ' '

     C                   IF        WCTRY = BBCOLC
     C                   EVAL      DDCDOM = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkCtrDN  - Check for country of domicile indicia (NAHO)    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkCtrDN    BEGSR

     C                   EVAL      DDCDOM = ' '

     C                   IF        WCTRY = NHCOLC
     C                   EVAL      DDCDOM = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWrtRptC - Write CRS customer detail to report               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrWrtRptC     BEGSR

     C                   EVAL      DDCUST = CDCUST
     C     KCRDF         CHAIN     SDCRDFL1
     C                   EVAL      CFCUST = CDCUST
     C                   EVAL      CFCTYP = CRTYPE
     C                   EVAL      CFRPTN = BBCRNM
     C                   EVAL      CFCTRY = WCTRY
     C                   EVAL      CFREPT = CDREPT
     C                   EVAL      CFCRSA = DDCRSA
     C                   EVAL      CFCODO = CDCODO
     C                   EVAL      CFJACM = CDJACM
     C                   EVAL      CFMAIL = CDMAIL
     C                   EVAL      CFPHON = CDPHON
     C                   EVAL      CFRPAY = CDRPAY
     C                   EVAL      CFTINI = DDTINN
     C                   EVAL      CFAUHO = CDAUHO

     C                   IF        %FOUND(SDCRDFL1)
     C                   UPDATE    SDCRDFD0
     C                   ELSE
     C                   WRITE     SDCRDFD0
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWrtRptN - Write CRS customer detail to report               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrWrtRptN     BEGSR

     C                   EVAL      DDNAHO = CNNAHO
     C                   EVAL      CGNAHO = CNNAHO
     C                   EVAL      CGNTYP = NRTYPE
     C                   EVAL      CGRPTN = NHNARN
     C                   EVAL      CGCTRY = WCTRY
     C                   EVAL      CGREPT = CNREPT
     C                   EVAL      CGCRSA = DDCRSA
     C                   EVAL      CGCODO = CNCODO
     C                   EVAL      CGJACM = CNJACM
     C                   EVAL      CGMAIL = CNMAIL
     C                   EVAL      CGPHON = CNPHON
     C                   EVAL      CGRPAY = CNRPAY
     C                   EVAL      CGTINI = DDTINN
     C                   EVAL      CGAUHO = DDAUHO

     C     KCRNF         CHAIN     SDCRNFL1
     C                   IF        %FOUND(SDCRNFL1)
     C                   UPDATE    SDCRNFD0
     C                   ELSE
     C                   WRITE     SDCRNFD0
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkTIN - Check for TIN indicia                              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkTIN      BEGSR

     C                   EVAL      DDTINN = ' '

     C                   IF        WCTRY <> BBCOLC
     C                             AND CDTINN <> *Blanks
     C                   EVAL      DDTINN = 'Y'
     C                   ENDIF

     C                   IF        WCTRY = BBCOLC
     C                             AND E5TINO <> *Blanks
     C                   EVAL      DDTINN = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkTNN - Check for TIN indicia (NAHO)                       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkTNN      BEGSR

     C                   EVAL      DDTINN = ' '

     C                   IF        WCTRY <> NHCOLC
     C                             AND CNTINN <> *Blanks
     C                   EVAL      DDTINN = 'Y'
     C                   ENDIF

     C                   IF        WCTRY = NHCOLC
     C                             AND NHTINO <> *Blanks
     C                   EVAL      DDTINN = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvCRSA  - Retrieve CRS Agreement of the country            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRtvCRSA     BEGSR

     C                   EVAL      WFOUND = ' '
     C                   EVAL      DDCRSA = *Blanks
     C                   EVAL      WWFIND = *Blanks
     C                   EVAL      WWFIND = WCTRY
     C                   MOVE      WCOLC         WWFIND
     C                   EVAL      M = %LOOKUP(WWFIND:PCtry1)
     C                   IF        M <> 0
     C                   EVAL      DDCRSA = PCrsa1(M)
     C                   EVAL      WFOUND = 'Y'
     C                   ELSE

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCTRY         WPCTRT
     C                   PARM      WCOLC         WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = *Blanks
     C                   EVAL      PCtry1(O) = WWFIND
     C                   EVAL      PCrsa1(O) = EWCRSA
     C                   EVAL      DDCRSA = EWCRSA
     C                   EVAL      O = O + 1
     C                   EVAL      WFOUND = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        WFOUND = ' '
     C                   EVAL      M = %LOOKUP(WCTRY:PCtry2)
     C                   IF        M <> 0
     C                   EVAL      DDCRSA = PCrsa2(M)
     C                   ELSE
     C                   EVAL      WPCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCTRY         WPCTRT
     C                   PARM                    WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = *BLANK
     C                   EVAL      PCtry2(P) = WCTRY
     C                   EVAL      PCrsa2(P) = EWCRSA
     C                   EVAL      P = P + 1
     C                   EVAL      DDCRSA = EWCRSA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkPhnMail - Check mailing country and phone number         *
      *                country                                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkPhnMail  BEGSR

     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '

     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCUST        PCustNo
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRTCD = *Blanks
     C                   IF        E5CTR1 = WCTRY OR
     C                             E5CTR2 = WCTRY OR
     C                             E5CTR3 = WCTRY OR
     C                             E5CTR4 = WCTRY OR
     C                             E5CTR5 = WCTRY
     C                   EVAL      DDMAIL = 'Y'
     C                   ENDIF
     C                   IF        E5PHN1 = WCTRY OR
     C                             E5PHN2 = WCTRY OR
     C                             E5PHN3 = WCTRY OR
     C                             E5PHN4 = WCTRY OR
     C                             E5PHN5 = WCTRY
     C                   EVAL      DDPHON = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkPhnMalN - Check mailing country and phone number         *
      *                country (NAHO)                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrChkPhnMalN  BEGSR

     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '

     C                   IF        NHMCT1 = WCTRY OR
     C                             NHMCT2 = WCTRY OR
     C                             NHMCT3 = WCTRY OR
     C                             NHMCT4 = WCTRY OR
     C                             NHMCT5 = WCTRY
     C                   EVAL      DDMAIL = 'Y'
     C                   ENDIF

     C                   IF        NHPCT1 = WCTRY OR
     C                             NHPCT2 = WCTRY OR
     C                             NHPCT3 = WCTRY OR
     C                             NHPCT4 = WCTRY OR
     C                             NHPCT5 = WCTRY
     C                   EVAL      DDPHON = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltLvl - Process multi level joint account                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrMltLvl      BEGSR

     C                   EVAL      KJANO = *Blanks
     C                   EVAL      KMEMB = *Blanks
     C                   EVAL      Pmember(1) = *Blanks
     C                   EVAL      PTYPODS(1) = %SUBST(PTYPO:1:1)
     C                   EVAL      PTYPODS(2) = %SUBST(PTYPO:2:1)
     C                   EVAL      PTYPODS(3) = %SUBST(PTYPO:3:1)
     C                   EVAL      PTYPODS(4) = %SUBST(PTYPO:4:1)
     C                   EVAL      PTYPODS(5) = %SUBST(PTYPO:5:1)

     C     *LOVAL        SETLL     SDJACCL2
     C                   READ      SDJACCL2

     C                   DOW       NOT %EOF(SDJACCL2)

     C                   EVAL      A = 1
     C                   EVAL      Pmember(1) = JSJANO
     C                   EVAL      JCJANO = JSJANO
     C                   EVAL      JCCUST = JSCUST
     C                   EVAL      JCNAHO = JSNAHO
     C                   EXSR      SrMltLvl2

     C                   READ      SDJACCL2
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltLvl2 - Process multi level joint account                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrMltLvl2     BEGSR

     C                   GOTO      FirstProc

     C     CReposition   TAG

     C     KJAC1         SETLL     SDJACCL1
     C     NReposition   TAG
     C                   READ      SDJACCL1

      ** Read another record
     C                   IF        WREAD = 'Y'
     C                   READ      SDJACCL1
     C                   ENDIF
     C                   EVAL      WREAD = ' '

      ** End of End of File, quit
     C                   IF        %EOF(SDJACCL1)
     C                   GOTO      END
     C                   ENDIF

     C                   IF        KJANO = JCJANO

     C     FirstProc     TAG

     C                   EVAL      KJANO = JCJANO
     C                   IF        JCNAHO <> *Blanks

     C     JCNAHO        SETLL     SDCRSNL2
     C     JCNAHO        READE     SDCRSNL2

     C                   DOW       NOT %EOF(SDCRSNL2)
     C                   IF        JRREPT = 'Y'

      ** Set array pointer
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      n = n - 1
     C                   EVAL      KCTRY = JRCTRY
     C                   EXSR      SrMltJUpdat
     C                   ENDIF

     C     JCNAHO        READE     SDCRSNL2
     C                   ENDDO

     C                   EVAL      KJANO = JCJANO

     C                   GOTO      NReposition
     C                   ENDIF

     C                   IF        JCCUST <> *Blanks

     C***                EVAL      n = %LOOKUP('      ':Pmember)
     C***                EVAL      Pmember(n) = JCCUST

     C     JCCUST        SETLL     SDCRSDL2
     C     JCCUST        READE     SDCRSDL2

     C                   DOW       NOT %EOF(SDCRSDL2)
     C                   IF        JQREPT = 'Y'

      ** Set array pointer
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      n = n - 1
     C                   EVAL      KCTRY = JQCTRY
     C                   EXSR      SrMltJUpdat
     C                   ENDIF

     C     JCCUST        READE     SDCRSDL2
     C                   ENDDO

     C                   EVAL      KJANO = JCCUST
     C                   EVAL      KMEMB = *Blanks

     C                   ENDIF

     C                   ELSE
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   IF        n = 2
     C                   GOTO      END
     C                   ENDIF

     C                   EVAL      KJANO = Pmember(n-2)
     C                   EVAL      KMEMB = Pmember(n-1)
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
      * SrMltJUpdat - Update all customers involve                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrMltJUpdat   BEGSR

     C                   EVAL      KCUST = Pmember(n)
     C                   EVAL      DDCUST = KCUST
     C                   EVAL      DDCRSA = ' '
     C                   EVAL      DDTINN = ' '

     C                   DOW       n <> 0

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      KCUST         Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   EVAL      WCOLC = BBCOLC
     C                   EVAL      WCTRY = KCTRY
     C                   EXSR      SrRtvCRSA

     C                   CLEAR                   SDCRSH
     C     KCUST         CHAIN     SDCRSHL0
     C                   IF        (%LOOKUP(CRTYPE:PTypoDS) <> 0
     C                             AND CRTYPE <> *Blanks)

     C     KCRD2         CHAIN     SDCRSDL1
     C                   IF        %FOUND(SDCRSDL1)
     C                   EVAL      SDCRSDB = SDCRSD
     C                   EVAL      WREPT = ' '
     C                   IF        CDREPT = ' '
     C                   EVAL      WREPT = 'Y'
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   ENDIF

     C                   IF        CDJACM <> 'Y'
     C                             OR WREPT = 'Y'
     C                   EVAL      CDJACM = 'Y'
     C                   EXSR      SrWrtRptC
     C                   ENDIF

     C                   EVAL      CDJACM = 'Y'
     C                   EVAL      SDCRSDA = SDCRSD
     C                   IF        SDCRSDB <> SDCRSDA
     C                   EVAL      %SUBST(PBefCRSD:A:218) = SDCRSDB
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   ENDIF
     C                   UPDATE    SDCRSDD0
     C                   ELSE

     C                   EVAL      CDCUST = Pmember(n)
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      CDCUST        Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C***                EVAL      WCTRY = CDCTRY
     C***                EVAL      WCOLC = BBCOLC
     C***                EXSR      SrRtvCRSA

     C                   EVAL      CDCTRY = KCTRY
     C                   EVAL      WCTRY = CDCTRY
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   EVAL      CDEVE1 = *Blanks
     C                   EVAL      CDEVS1 = *Zero
     C                   EVAL      CDEVE2 = *Blanks
     C                   EVAL      CDEVS2 = *Zero
     C                   EVAL      CDEVE3 = *Blanks
     C                   EVAL      CDEVS3 = *Zero
     C                   EVAL      CDEVE4 = *Blanks
     C                   EVAL      CDEVS4 = *Zero
     C                   EVAL      CDEVE5 = *Blanks
     C                   EVAL      CDEVS5 = *Zero
     C                   EVAL      CDTINN = *Blanks
     C                   EVAL      CDEFFD = *Zero
     C                   EVAL      CDEXPD = *Zero
     C                   EVAL      CDCODO = *Blanks
     C                   EVAL      CDJACM = 'Y'
     C                   EVAL      CDMAIL = *Blanks
     C                   EVAL      CDPHON = *Blanks
     C                   EVAL      CDRPAY = *Blanks
     C                   EVAL      CDTINS = *Blanks
     C                   EVAL      CDAUHO = *Blanks
     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   EVAL      %SUBST(PBefCRSD:A:218) = *Blanks
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   WRITE     SDCRSDD0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      n = n - 1
     C                   IF        n > 0
     C                   EVAL      KCUST = Pmember(n)
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAutLvl - Process multi level authority holder               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrAutLvl      BEGSR

     C                   EVAL      KCAUT = *Blanks
     C                   EVAL      KAUTH = *Blanks
     C                   EVAL      Pmember(1) = *Blanks
     C                   EVAL      PTYPODS(1) = %SUBST(PTYPO:1:1)
     C                   EVAL      PTYPODS(2) = %SUBST(PTYPO:2:1)
     C                   EVAL      PTYPODS(3) = %SUBST(PTYPO:3:1)
     C                   EVAL      PTYPODS(4) = %SUBST(PTYPO:4:1)
     C                   EVAL      PTYPODS(5) = %SUBST(PTYPO:5:1)

     C     *LOVAL        SETLL     SDCUAHL0
     C                   READ      SDCUAHL0

     C                   DOW       NOT %EOF(SDCUAHL0)

     C                   EVAL      Pmember(1) = C2CUST
     C                   EVAL      CACUST = C2CUST
     C                   EVAL      CAAUTH = C2AUTH
     C                   EXSR      SrAutLvl2

     C                   READ      SDCUAHL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAutLvl2 - Process multi level authority holder              *
      *                                                               *
      * Called by: SrAutLvl                                           *
      *                                                               *
      * Calls: SrAutHUpdat                                            *
      *                                                               *
      *****************************************************************

     C     SrAutLvl2     BEGSR

     C                   GOTO      Au1stProc

     C     AuCRepositn   TAG

     C     KCUAH         SETLL     SDCUAHL1
     C     AuNRepositn   TAG
     C                   READ      SDCUAHL1

      ** Read another record
     C                   IF        WREAD = 'Y'
     C                   READ      SDCUAHL1
     C                   ENDIF
     C                   EVAL      WREAD = ' '

      ** End of End of File, quit
     C                   IF        %EOF(SDCUAHL1)
     C                   GOTO      AuEND
     C                   ENDIF

     C                   IF        KCAUT = CACUST

     C     Au1stProc     TAG

     C                   EVAL      KCAUT = CACUST
     C                   IF        CAAUTH <> *Blanks

      ** Check if Authority Holder is a Non-Account Holder
     C     CAAUTH        CHAIN     SDNAHOL0
     C                   IF        %FOUND(SDNAHOL0)

      ** NAHO authority Holder CRS details
     C     CAAUTH        SETLL     SDCRSNL2
     C     CAAUTH        READE     SDCRSNL2

     C                   DOW       NOT %EOF(SDCRSNL2)
     C                   IF        JRREPT = 'Y'

      ** Set array pointer
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      n = n - 1
     C                   EVAL      KCTRY = JRCTRY
     C                   EXSR      SrAutHUpdat
     C                   ENDIF

     C     CAAUTH        READE     SDCRSNL2
     C                   ENDDO

     C                   EVAL      KCAUT = CACUST
     C                   GOTO      AuNRepositn

     C                   ELSE
      ** CUST Authority Holder CRS details

     C                   EVAL      KAUTC = CAAUTH
     C     KAUTC         SETLL     SDCRSDL2
     C     KAUTC         READE     SDCRSDL2

     C                   DOW       NOT %EOF(SDCRSDL2)
     C                   IF        JQREPT = 'Y'

      ** Set array pointer
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   EVAL      n = n - 1
     C                   EVAL      KCTRY = JQCTRY
     C                   EXSR      SrAutHUpdat
     C                   ENDIF

     C     KAUTC         READE     SDCRSDL2
     C                   ENDDO

     C                   EVAL      KCAUT = CAAUTH
     C                   EVAL      KAUTH = *Blanks
     C                   ENDIF
     C                   ENDIF

     C                   ELSE
     C                   EVAL      n = %LOOKUP('      ':Pmember)
     C                   IF        n = 2
     C                   GOTO      AuEND
     C                   ENDIF

     C                   EVAL      KCAUT = Pmember(n-2)
     C                   EVAL      KAUTH = Pmember(n-1)
     C                   EVAL      Pmember(n-1) = *Blanks
     C                   EVAL      WREAD = 'Y'
     C                   ENDIF

     C                   GOTO      AuCRepositn
     C     AuEND         TAG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMltJUpdat - Update all customers involve                    *
      *                                                               *
      * Called by: SrAutLvl2                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrAutHUpdat   BEGSR

     C                   EVAL      KCUST = Pmember(n)
     C                   EVAL      DDCUST = KCUST
     C                   EVAL      DDCRSA = ' '
     C                   EVAL      DDTINN = ' '

     C                   DOW       n <> 0

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      KCUST         Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   EVAL      WCOLC = BBCOLC
     C                   EVAL      WCTRY = KCTRY
     C                   EXSR      SrRtvCRSA

     C                   CLEAR                   SDCRSH
     C     KCUST         CHAIN     SDCRSHL0
     C                   IF        (%LOOKUP(CRTYPE:PTypoDS) <> 0
     C                             AND CRTYPE <> *Blanks)

     C     KCRD2         CHAIN     SDCRSDL1
     C                   IF        %FOUND(SDCRSDL1)
     C                   EVAL      SDCRSDB = SDCRSD
     C                   EVAL      WREPT = ' '
     C                   IF        CDREPT = ' '
     C                   EVAL      WREPT = 'Y'
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   ENDIF

     C                   IF        CDAUHO <> 'Y'
     C                             OR WREPT = 'Y'
     C                   EVAL      CDAUHO = 'Y'
     C                   EXSR      SrWrtRptC
     C                   ENDIF

     C                   EVAL      CDAUHO = 'Y'
     C                   EVAL      SDCRSDA = SDCRSD
     C                   IF        SDCRSDB <> SDCRSDA
     C                   EVAL      %SUBST(PBefCRSD:A:218) = SDCRSDB
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   ENDIF
     C                   UPDATE    SDCRSDD0
     C                   ELSE

     C                   EVAL      CDCUST = Pmember(n)
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      CDCUST        Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   EVAL      CDCTRY = KCTRY
     C                   EVAL      WCTRY = CDCTRY
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   EVAL      CDEVE1 = *Blanks
     C                   EVAL      CDEVS1 = *Zero
     C                   EVAL      CDEVE2 = *Blanks
     C                   EVAL      CDEVS2 = *Zero
     C                   EVAL      CDEVE3 = *Blanks
     C                   EVAL      CDEVS3 = *Zero
     C                   EVAL      CDEVE4 = *Blanks
     C                   EVAL      CDEVS4 = *Zero
     C                   EVAL      CDEVE5 = *Blanks
     C                   EVAL      CDEVS5 = *Zero
     C                   EVAL      CDTINN = *Blanks
     C                   EVAL      CDEFFD = *Zero
     C                   EVAL      CDEXPD = *Zero
     C                   EVAL      CDCODO = *Blanks
     C                   EVAL      CDJACM = 'Y'
     C                   EVAL      CDMAIL = *Blanks
     C                   EVAL      CDPHON = *Blanks
     C                   EVAL      CDRPAY = *Blanks
     C                   EVAL      CDTINS = *Blanks
     C                   EVAL      CDAUHO = *Blanks
     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   EVAL      %SUBST(PBefCRSD:A:218) = *Blanks
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   WRITE     SDCRSDD0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      n = n - 1
     C                   IF        n > 0
     C                   EVAL      KCUST = Pmember(n)
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCheckREGP - Process Regular Payments Indicia                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCheckREGP   BEGSR

     C***  KCUST         SETLL     SDCRSHL1
     C***                READ      SDCRSHL1

     C***                DOW       NOT %EOF(SDCRSHL1)
     C***                          AND KCUST = C1CUST

     C***                IF        (C1TYPE = PTYPE)
     C***                          AND (C1INFO = ' '
     C***                          OR C1INFO = 'N')

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C***                PARM      C1CUST        Pkey1
     C                   PARM      KCUST         Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C     KCUST         CHAIN     SDCRSHL1
     C                   IF        C1INFO = ' '
     C                             OR CRINFO = 'N'
     C                   EVAL      CRTYPE = C1TYPE
     C                   EVAL      DDREGP = ' '
     C                   EVAL      DDCDOM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '
     C                   EVAL      DDTINN = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      PCountry = *Blanks

     C                   CALL      'SD000558'
     C                   PARM                    PReturn
     C***                PARM      C1CUST        DDCUST
     C                   PARM      KCUST         DDCUST
     C                   PARM                    DDREGP
     C                   PARM                    PCountry

     C     KCUST         SETLL     SDCRSDL1
     C                   READ      SDCRSDL1
     C                   DOW       NOT %EOF(SDCRSDL1)
     C                             AND CDCUST = KCUST
     C                             AND CDRPAY = 'Y'
     C                   EVAL      SDCRSDB = SDCRSD
     C                   EVAL      Q = %LOOKUP(CDCTRY:PCountry)
     C                   IF        Q = 0
     C                   EVAL      CDRPAY = ' '
     C                   EVAL      WCTRY = CDCTRY
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA
     C                   EXSR      SrChkTIN
     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   IF        SDCRSDB <> SDCRSDA
     C                   EVAL      %SUBST(PBefCRSD:A:218) = SDCRSDB
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   ENDIF
     C                   UPDATE    SDCRSDD0
     C                   ENDIF
     C                   READ      SDCRSDL1
     C                   ENDDO

     C                   IF        DDREGP = 'Y'
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      KCTRY = PCountry(X)
     C                   EVAL      WCTRY = KCTRY
     C                   EVAL      KCUST = C1CUST

     C                   IF        KCTRY <> *Blanks
     C     KCRD2         CHAIN     SDCRSDL1
     C                   IF        %FOUND(SDCRSDL1)
     C                   EVAL      SDCRSDB = SDCRSD

      ** Update subject to reporting

     C                   EVAL      WREPT = ' '
     C                   IF        CDREPT = ' '
     C                   EVAL      WREPT = 'Y'
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks
     C                   ENDIF

     C                   IF        CDRPAY <> 'Y'
     C                             OR WREPT = 'Y'
     C                   EVAL      CDRPAY = 'Y'
     C                   EXSR      SrWrtRptC
     C                   ENDIF

     C                   EVAL      CDRPAY = 'Y'
     C                   EVAL      SDCRSDA = SDCRSD
     C                   IF        SDCRSDB <> SDCRSDA
     C                   EVAL      %SUBST(PBefCRSD:A:218) = SDCRSDB
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   ENDIF
     C                   UPDATE    SDCRSDD0

     C                   ELSE

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      C1CUST        Pkey1
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   EVAL      WCTRY = PCountry(X)
     C                   EVAL      WCOLC = BBCOLC
     C                   EXSR      SrRtvCRSA

     C                   EVAL      CDCUST = C1CUST
     C                   EVAL      CDCTRY = PCountry(X)
     C                   EVAL      WCTRY = CDCTRY
     C                   EVAL      CDREPT = 'Y'
     C                   EVAL      CDREPR = *Blanks

     C                   EVAL      CDEVE1 = *Blanks
     C                   EVAL      CDEVS1 = *Zero
     C                   EVAL      CDEVE2 = *Blanks
     C                   EVAL      CDEVS2 = *Zero
     C                   EVAL      CDEVE3 = *Blanks
     C                   EVAL      CDEVS3 = *Zero
     C                   EVAL      CDEVE4 = *Blanks
     C                   EVAL      CDEVS4 = *Zero
     C                   EVAL      CDEVE5 = *Blanks
     C                   EVAL      CDEVS5 = *Zero
     C                   EVAL      CDTINN = *Blanks
     C                   EVAL      CDEFFD = *Zero
     C                   EVAL      CDEXPD = *Zero
     C                   EVAL      CDCODO = *Blanks
     C                   EVAL      CDJACM = *Blanks
     C                   EVAL      CDMAIL = *Blanks
     C                   EVAL      CDPHON = *Blanks
     C                   EVAL      CDRPAY = 'Y'
     C                   EVAL      CDTINS = *Blanks
     C                   EVAL      CDAUHO = *Blanks
     C                   EXSR      SrWrtRptC
     C                   EVAL      SDCRSDA = SDCRSD
     C                   EVAL      %SUBST(PBefCRSD:A:218) = *Blanks
     C                   EVAL      %SUBST(PAftCRSD:A:218) = SDCRSDA
     C                   EVAL      A = A + 218
     C                   WRITE     SDCRSDD0
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C***                ENDIF

     C***                READ      SDCRSHL1
     C***                ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRegPayInst - Regular Payment Instructions Indicia           *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRegPayInst  BEGSR

     C                   EVAL      DDREGP = ' '

      ** Check Customer Number
     C                   EVAL      KOTPAYType = 'C'
     C                   EVAL      KOTPAYKey35 = DDCUST
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL1
     C                   IF        CUCOLC = WCTRY
     C                             AND %FOUND(SDCUSTL1)
     C                   EVAL      DDREGP = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

      ** Check Customer Shortname
     C                   EVAL      KOTPAYType = 'S'
     C                   EVAL      KOTPAYKey35 = BBCSSN
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL1
     C                   IF        CUCOLC = WCTRY
     C                             AND %FOUND(SDCUSTL1)
     C                   EVAL      DDREGP = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

      ** Check Nostros Attached to the customer
     C     DDCUST        SETLL     SDNOSTL2
     C     DDCUST        READE     SDNOSTL2

     C                   DOW       NOT %EOF(SDNOSTL2)
     C                   EVAL      KOTPAYType = 'A'
     C                   EVAL      KOTPAYKey35 = A7CYCD + A7NONB
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL1
     C                   IF        CUCOLC = WCTRY
     C                   EVAL      DDREGP = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

     C     DDCUST        READE     SDNOSTL2
     C                   ENDDO

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

     C     *ENTRY        PLIST
      ** Return Code
      ** Transaction ID (Customer Number or NAHO Reference)
      ** Source API (C-Customer, N-Non-Account Holder, J-Joint Accounts)
      ** Classification if Indicia Found (M and J mode only)
      ** Classification if Indicia Not Found (M and J mode only)
      ** Mode (M-Manual, A-Automatic, I-Info Only)
     C                   PARM                    PReturn
     C                   PARM                    Wupdat
     C                   PARM                    PTYPO

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY

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

     C                   EVAL      CSE023 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSE023 = 'Y'
     C                   ENDIF

     C                   EVAL      CSE024 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE024'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSE024 = 'Y'
     C                   ENDIF

     C                   EVAL      CSD092 = 'N'

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSD092'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSD092 = 'Y'
     C                   ENDIF

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      SYSVAL1       POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP02
     C                   PARM                    PVL02

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBKEY = SYSVAL1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PVL01  <> *BLANKS
     C                   MOVEL     PVL01         WNEffDate

     C                   CALL      'ZDATE1'                             90
     C                   PARM                    PRetCode
     C                   PARM                    WNEffDate
     C                   PARM      BJDFIN        PDateFormat
     C                   PARM      *ZERO         WEffDate
     C                   ENDIF

     C     KCRD2         KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KCTRY

     C     KCRN2         KLIST
     C                   KFLD                    KNAHO
     C                   KFLD                    KCTRY

     C     KOTPAYKey     KLIST
     C                   KFLD                    KOTPAYType
     C                   KFLD                    KOTPAYKey35

     C     KCRDF         KLIST
     C                   KFLD                    KCTRY
     C                   KFLD                    DDCUST

     C     KCRNF         KLIST
     C                   KFLD                    KCTRY
     C                   KFLD                    DDNAHO

     C     KJAC1         KLIST
     C                   KFLD                    KJANO
     C                   KFLD                    KMEMB

     C     KJAC2         KLIST
     C                   KFLD                    KJANO
     C                   KFLD                    KMEMN

     C     KCUAH         KLIST
     C                   KFLD                    KCAUT
     C                   KFLD                    KAUTH

     C                   ENDSR

      *****************************************************************
      /EJECT
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

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
