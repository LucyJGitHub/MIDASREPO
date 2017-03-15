     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('FATCA US Indicia Search Tool Enquiry and Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000733 - FATCA US Indicia Search Tool Enquiry and Report   *
      *                                                               *
      *  Function:  This module reports all FATCA Customers with      *
      *             US Indicia changes due to the FATCA US Indicia    *
      *             search tool.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      *  Prev Amend No. MD027209C          Date 08Oct14               *
      *                 MD029835           Date 29Aug14               *
      *                 MD027209B          Date 25Sep14               *
      *                 MD027209           Date 07Aug14               *
      *                 MD027682           Date 28Aug14               *
      *                 MD027498A          Date 24Jun14               *
      *                 MD027498           Date 20Jun14               *
      *                 MD026633           Date 02May14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  MD027209C - F4-Print Report is not available in USIT and NCUP*
      *  MD029835 - US Indicia Tool is looping when F11 is pressed    *
      *  MD027209B - F4-Print Report is not available in USIT and NCUP*
      *  MD027209 - F4-Print Report is not available in USIT and NCUP *
      *  MD027682 - Reporting Type is not Reflected During Information*
      *             and Update Mode in USIT                           *
      *             Includes Fix MD028682                             *
      *  MD027498A- Infinite loop when both new Classifications are   *
      *             blanks                                            *
      *  MD027498 - Inconsistent behaviour of setting New             *
      *             Classification Code in selection criteria to blank*
      *  MD026633 - Missing Fixes on SD000730DF from lower releases   *
      *             (Recompile)                                       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
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
     FSD000733DFCF   E             WORKSTN
     F                                     SFILE(SD000733S0:DDSFRN)

     FSDFATCL0  IF   E           K DISK    INFSR(*PSSR)

     FSDFCLSL0  UF A E           K DISK    INFSR(*PSSR)

     FSDFCLSL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCLSD0:SDFCLSD1)

     FSDFCLSL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCLSD0:SDFCLSD2)

     FSDFCL1L0  UF   E           K DISK    INFSR(*PSSR)

     FSDFCL1L1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCL1D0:SDFCL1D2)

     FSDFCLDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DR:2)

     FSDFTNHL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTNHD0:SDFTNHD4)

     FSDFTCSL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTCSD0:SDFTCSD4)

     FSDFNBKL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTNHD0:SDFNBKD0)
     F                                     PREFIX(BN:2)

     FSDFCBKL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTCSD0:SDFCBKD0)
     F                                     PREFIX(BC:2)

      ** US Indicia Search Tool Customer Report
     FSD000733P1O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL1)

      ** US Indicia Search Tool Non-Account Holder Report
     FSD000733P2O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL2)

      ** US Indicia Search Tool Non-Account Holder Report
     FSD000733AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F                                     USROPN                                          MD027209C
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      ** Program Status Data Structure

      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwrds. ***
      ** +-----------------------------------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     DMaxArray         C                   CONST(999)
     DIndiciaCount     C                   CONST(11)

      ** Define maximum number of FATCA Customer Types
      ** If this increases, need to add the new type as an additional
      ** compile time array entry
     DMaxType          C                   CONST(5)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Run-time Array for Country Codes with FATCA Flag
     DCtryCodeArr      S              2    DIM(MaxArray)

      ** Run-time Array for FATCA Classitfication codes
     DClassArr         S              5A   DIM(MaxArray)

      ** Run-time Array for FATCA Customer Types
     DTypeArr          S              1A   DIM(MaxType)
     D                                     CTDATA

      ** Compile-Type Array for FATCA Reporting Type                                        MD027682
     DRTypVal          S              1A   DIM(MaxType)                                     MD027682
     D                                     CTDATA                                           MD027682

      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Bank Details
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for Bank Details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** External data structure for Bank Details
     D SDFATC        E DS                  EXTNAME(SDFATCPD)

      ** ZSFILE Parameters
     D ZSEQ            S              5
     D ZENTY           S              3
     D ZSERR           S              1
     D ZSNUM           S              6  0

      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** SPOOL Information Data Structure for ZSFILE
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0

      ** SPOOL Information Data Structure for ZSFILE - AU Report
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** Data Structure for the save 2 consecutive previous keys
     D SAVKEY          DS                  OCCURS(2)
     D  KTYPSV                 1      1
     D  KPCLSV                 2      6
     D  KCCLSV                 7     11
     D  KRTYPV                12     12                                                     MD027682
      ** Data Structure for Non-Account Holder Indicia
     DSDFTNH         E DS                  EXTNAME(SDFTNHPD)

      ** Data Structure for Customer Indicia
     DSDFTCS         E DS                  EXTNAME(SDFTCSPD)

      ** Data Structure for Non-Account Holder Indicia
     DSDFNBK         E DS                  EXTNAME(SDFNBKPD)
     D                                     PREFIX(BN:2)

      ** Data Structure for Non-Account Holder Indicia
     DSDFCBK         E DS                  EXTNAME(SDFCBKPD)
     D                                     PREFIX(BC:2)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D Index           S              3S 0 INZ(0)
     D KCust           S              6S 0
     D KCode           S              5A
     D KCType          S              1A

     D WCardF          S              1A
     D WClassCnt       S              4S 0 INZ(0)

      ** Define Array Indices
     D WClassI         S              3S 0
     D WTypeI          S              1S 0

      ** Parameters
     D PReturn         S              7A
     D PTranID         S             10A
     D PSource         S              1A
     D PIndicia        S              1A
     D PMode           S              1A

     D PRetCode        S              7A
     D POption         S             10A
     D TEST            S              1S 0 INZ(0)
     D WTFCCD          S              5A
     D WTFCTP          S              1A
     D WTFCD1          S              5A
     D WTFCD2          S              5A
     D WRqdLin         S              4P 0

     D WNNHTY          S                   LIKE(FNNHTY)
     D WNNHST          S                   LIKE(FNNHST)
     D WNPCLA          S                   LIKE(FNPCLA)
     D WNCLAC          S                   LIKE(FNCLAC)
     D WNRPTT          S                   LIKE(FNRPTT)                                     MD027682

     D WOpenP1         S              1A   INZ('N')
     D WOpenP2         S              1A   INZ('N')
     D WLoadHead       S              1A   INZ('N')
     D WInitLoad       S              1A   INZ('Y')
     D WTerminate      S              1A   INZ('N')

     D PRTCD           S              7A
     D POPTN           S              7A
     D PCLAS           S              5A
     D PKey1           S             10A
     D PKySt           S              7A
     D WPrint          S              1A                                                   MD027209B

      ** Current Keys
     D KCTYP           S              1A   INZ(' ')
     D KSTYP           S              2A   INZ(' ')
     D KPCLS           S              5A   INZ(' ')
     D KCCLS           S              5A   INZ(' ')
     D KCNUM           S              6A   INZ(' ')
     D KNAHO           S             10A   INZ(' ')

      ** Previous Keys
     D KPCTYP          S              1A   INZ(' ')
     D KPSTYP          S              2A   INZ(' ')
     D KPPCLS          S              5A   INZ(' ')
     D KPCCLS          S              5A   INZ(' ')
     D KPRTYP          S              1A   INZ(' ')
      ** Header Keys                                                                        MD027209
     D HCTYP           S              1A   INZ(' ')                                         MD027209
     D HPCLS           S              5A   INZ(' ')                                         MD027209
     D HCCLS           S              5A   INZ(' ')                                         MD027209
     D HCRTP           S              5A   INZ(' ')                                         MD027209

     D KRFCCD          S              5A
     D KRFCTP          S              1A
     D KRFCD1          S              5A
     D KRRTYP          S              1A
     D KRTYP           S              1A                                                    MD027682

     D WPageCtr        S              3  0
     D WArrIndx        S              1  0
     D RepTypIdx       S              1  0                                                  MD027682
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

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************


     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   EXSR      SrPrepDrive                                              MD028682
     C**********         EXSR      SRProcReport                                             MD027209
     C**********         EXSR      SrPrepDrive                                              MD028682
     C                   EXSR      SREnquiry

     C                   SETON                                        LR
     C                   RETURN


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnquiry - Process Enquiry                                   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SREnquiry     BEGSR

     C                   EXSR      SRInitSFL

     C                   EVAL      WPrint = 'N'                                            MD027209B
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN81 = *OFF

     C     *LOVAL        SETLL     SDFCLDL0
     C                   READ      SDFCLDL0

     C                   DOW       NOT *INKC = *ON
     C                             AND NOT *INKL = *ON
     C                             AND WTerminate <> 'Y'
     C                   EVAL      WLoadHead = 'N'
     C                   IF        NOT %EOF(SDFCLDL0)

     C                   IF        (KCTYP <> DRFCTP
     C                             OR  KPCLS <> DRFCCD
     C**********                   OR  KCCLS <> DRFCD1)                                     MD027682
     C                             OR  KCCLS <> DRFCD1                                      MD027682
     C                             OR  KRTYP <> DRRTYP)                                     MD027682
     C                             OR  *INKG = *ON
     C                             OR  *INKD = *ON                                          MD027209
      ** Display
     C                   EVAL      KCTYP = DRFCTP
     C                   EVAL      KPCLS = DRFCCD
     C                   EVAL      KCCLS = DRFCD1
     C                   EVAL      KRTYP = DRRTYP                                           MD027682

     C                   EXSR      SRLoadCSFile
     C                   EXSR      SRLoadNSFile
     C                   ENDIF

     C                   IF        WLoadHead = 'N'

     C                   IF        *INKG = *ON
     C                   READP     SDFCLDL0
     C                   ELSE
     C                   READ      SDFCLDL0
     C                   ENDIF

     C                   IF        %EOF(SDFCLDL0)

      ** Display "No data to display" in screen then exit

     C                   IF        DDSFRN = 0
     C                   DOU       *INKD = *OFF                                            MD027209C
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN98 = *ON
     C                   WRITE     SD000733F1
     C                   EVAL      DDSFRN = 1
     C                   EXFMT     SD000733C0
     C                   IF        PMODE <> 'I' OR                                         MD027209B
     C                             *INKD = '1'                                             MD027209B
     C                   EVAL      *IN77 = *ON                                             MD027209B
     C                   EXSR      SRProcReport                                            MD027209B
     C**********         EVAL      *IN77 = *OFF                                  MD027209B MD027209C
     C                   ENDIF                                                             MD027209B
     C                   ENDDO                                                             MD027209C
     C                   EVAL      WTerminate = 'Y'
     C                   ITER
     C                   ENDIF

      ** Extract save previous key

     C                   IF        WArrIndx = 2

     C                   EVAL      WArrIndx = 1
     C     WArrIndx      OCCUR     SAVKEY
     C                   EVAL      KCTYP = KTYPSV
     C                   EVAL      KPCLS = KPCLSV
     C                   EVAL      KCCLS = KCCLSV
     C                   EVAL      KRTYP = KRTYPV                                           MD027682

     C                   ELSE

     C                   EVAL      WArrIndx = WArrIndx + 1
     C     WArrIndx      OCCUR     SAVKEY
     C                   EVAL      WArrIndx = 1
     C                   EVAL      KCTYP = KTYPSV
     C                   EVAL      KPCLS = KPCLSV
     C                   EVAL      KCCLS = KCCLSV
     C                   EVAL      KRTYP = KRTYPV                                           MD027682

     C                   ENDIF

      ** Do not display F8 if end of file for F8 is reach

     C                   IF        *INKH = *ON
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON

     C                   IF        WPageCtr = 0
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C     KCustKey1     SETGT     SDFCLDL0
     C                   READ      SDFCLDL0
     C                   ENDIF

      ** Do not display F7 if end of file for F7 is reach

     C                   IF        *INKG = *ON
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON
     C     KCustKey1     SETLL     SDFCLDL0
     C                   READP     SDFCLDL0
     C                   ENDIF

     C                   ELSE
     C                   ITER
     C                   ENDIF

     C                   ENDIF

     C                   IF        DDSFRN <> 0
     C                   EVAL      *IN98 = *OFF
     C                   ELSE
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

      ** Count the number of times F8 is press and subtract
      ** the number of times F7 is press, if counter = 0
      ** set non-display indicator for F7 = ON.

     C                   SELECT
     C                   WHEN      *INKH = *ON
     C                   IF        *IN79 <> *ON
     C                   EVAL      WPageCtr = WPageCtr + 1
     C                   ENDIF
     C                   WHEN      *INKG = *ON
     C                   EVAL      WPageCtr = WPageCtr - 1
     C                   IF        WPageCtr = 0 AND
     C                             *IN79 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
     C                   ENDSL
     C
     C                   WRITE     SD000733F1

     C                   IF        DDSFRN <> 0
     C                   EVAL      DDSFRN = 1
     C                   ENDIF

     C                   EXFMT     SD000733C0

     C                   IF        *IN79 = *ON
     C                   EXSR      SRLoadCSFile
     C                   EXSR      SRLoadNSFile
     C                   ENDIF

     C                   EVAL      *IN77 = *OFF                                             MD027209
     C                   EVAL      *IN78 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   IF        PMODE <> 'I' AND                                        MD027209B
     C                             WPrint = 'N'                                            MD027209B
     C                   EXSR      SRProcReport                                            MD027209B
     C                   EVAL      WPrint = 'Y'                                            MD027209B
     C                   ENDIF                                                             MD027209B
                                                                                           MD027209B

      ** If Next has been pressed
     C                   SELECT
     C                   WHEN      *INKH = *ON

      ** Keep previous keys
     C                   EVAL      KPCTYP = KCTYP
     C                   EVAL      KPPCLS = KPCLS
     C                   EVAL      KPCCLS = KCCLS
     C                   EVAL      KPRTYP = KRTYP                                           MD027682

      ** Update key List
     C                   EVAL      KCTYP = DRFCTP
     C                   EVAL      KPCLS = DRFCCD
     C                   EVAL      KCCLS = DRFCD1
     C                   EVAL      KRTYP = DRRTYP                                           MD027682

     C     KCustKey1     SETGT     SDFCLDL0
     C                   READ      SDFCLDL0
     C                   IF        %EOF(SDFCLDL0)
     C                   EVAL      *IN81 = *OFF
     C                   ELSE
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
     C     KCustKey1     SETGT     SDFCLDL0

     C                   WHEN      *INKG = *ON

      ** Keep previous keys
     C                   EVAL      KPCTYP = KCTYP
     C                   EVAL      KPPCLS = KPCLS
     C                   EVAL      KPCCLS = KCCLS
     C                   EVAL      KPRTYP = KRTYP                                           MD027682

      ** Update key List
     C                   EVAL      KCTYP = DRFCTP
     C                   EVAL      KPCLS = DRFCCD
     C                   EVAL      KCCLS = DRFCD1
     C                   EVAL      KRTYP = DRRTYP                                           MD027682

     C     KCustKey1     SETLL     SDFCLDL0
     C                   READP     SDFCLDL0

     C                   IF        %EOF(SDFCLDL0)
     C                   EVAL      *IN82 = *OFF
     C                   ELSE
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   ENDIF

     C     KCustKey1     SETLL     SDFCLDL0

     C                   WHEN      *INKC
     C                             OR *INKL
     C                   ITER
     C                   WHEN      *INKD                                                    MD027209
     C                   EVAL      *IN77 = *ON                                              MD027209
     C                   EXSR      SRProcReport                                             MD027209
      ** Update key List                                                                    MD027209
     C                   EVAL      KCTYP = HCTYP                                            MD027209
     C                   EVAL      KPCLS = HPCLS                                            MD027209
     C                   EVAL      KCCLS = HCCLS                                            MD027209
     C                   EVAL      KRTYP = HCRTP                                            MD027209
     C     KCustKey1     SETLL     SDFCLDL0                                                 MD027209
     C                   READ      SDFCLDL0                                                 MD027209
     C                   ENDSL

     C                   ELSE
     C                   IF        DDSFRN = 0                                               MD029835
     C                   EVAL      *IN79 = *ON                                              MD029835
     C                   EVAL      *IN98 = *ON                                              MD029835
     C                   WRITE     SD000733F1                                               MD029835
     C                   EVAL      DDSFRN = 1                                               MD029835
     C                   EXFMT     SD000733C0                                               MD029835
     C                   EVAL      WTerminate = 'Y'                                         MD029835
     C                   ENDIF                                                              MD029835
                                                                                            MD029835

      ** Do not display F8 if end of file for F8 is reach

     C                   IF        *INKH = *ON
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON

     C     KCustKey1     SETGT     SDFCLDL0
     C                   READP     SDFCLDL0
     C                   ENDIF

      ** Do not display F7 if end of file for F7 is reach

     C                   IF        *INKG = *ON
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON
     C     KCustKey1     SETLL     SDFCLDL0
     C                   READ      SDFCLDL0
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadNSFile - Load Non Account Holders on the Subfile        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLoadNSFile  BEGSR

     C     KCustKey1     SETLL     SDFTNHL4
     C     KCustKey1     READE     SDFTNHL4

     C                   DOW       NOT %EOF(SDFTNHL4)

     C     FNNAHO        CHAIN     SDFNBKL0

     C                   IF        SDFTNH = SDFNBK
     C                             OR BNNAHO = *BLANKS
     C     KCustKey1     READE     SDFTNHL4
     C                   ITER
     C                   ENDIF

      ** Check if Header needs to be redisplayed
     C                   IF        WLoadHead = 'N'
     C                   EXSR      SRLoadHead
     C                   EVAL      WLoadHead ='Y'
     C                   ENDIF

     C                   IF        WInitLoad = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WInitLoad ='N'
     C                   ENDIF

     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    FNNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE  = 003
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        KTYPSV <> KCTYP OR
     C                             KPCLSV <> KPCLS OR
     C                             KRTYPV <> KRTYP OR                                       MD027682
     C                             KCCLSV <> KCCLS
     C                   IF        WArrIndx = 2

     C                   EVAL      WArrIndx = 1
     C     WArrIndx      OCCUR     SAVKEY
     C                   EVAL      KTYPSV = KCTYP
     C                   EVAL      KPCLSV = KPCLS
     C                   EVAL      KCCLSV = KCCLS
     C                   EVAL      KRTYPV = KRTYP                                           MD027682

     C                   ELSE

     C                   EVAL      WArrIndx = WArrIndx + 1
     C     WArrIndx      OCCUR     SAVKEY
     C                   EVAL      KTYPSV = KCTYP
     C                   EVAL      KPCLSV = KPCLS
     C                   EVAL      KCCLSV = KCCLS
     C                   EVAL      KRTYPV = KRTYP                                           MD027682

     C                   ENDIF
     C                   ENDIF

     C                   EVAL      #1REFN =  NHNAHO
     C                   EVAL      #1RNAM =  NHNARN

     C                   MOVEL     FNCBSV        #1BTHS
     C                   IF        FNCBOV = ' '
     C                   MOVE      '-'           #1BTHS
     C                   ELSE
     C                   MOVE      FNCBOV        #1BTHS
     C                   ENDIF

     C                   MOVEL     FNCDSV        #1DOMS
     C                   IF        FNCDOV = ' '
     C                   MOVE      '-'           #1DOMS
     C                   ELSE
     C                   MOVE      FNCDOV        #1DOMS
     C                   ENDIF

     C                   MOVEL     FNTESV        #1TELS
     C                   IF        FNTEOV = ' '
     C                   MOVE      '-'           #1TELS
     C                   ELSE
     C                   MOVE      FNTEOV        #1TELS
     C                   ENDIF

     C                   MOVEL     FNHMSV        #1MALS
     C                   IF        FNHMOV = ' '
     C                   MOVE      '-'           #1MALS
     C                   ELSE
     C                   MOVE      FNHMOV        #1MALS
     C                   ENDIF

     C                   MOVEL     FNCISV        #1CTZS
     C                   IF        FNCIOV = ' '
     C                   MOVE      '-'           #1CTZS
     C                   ELSE
     C                   MOVE      FNCIOV        #1CTZS
     C                   ENDIF

     C                   MOVEL     FNJASV        #1JACS
     C                   IF        FNJAOV = ' '
     C                   MOVE      '-'           #1JACS
     C                   ELSE
     C                   MOVE      FNJAOV        #1JACS
     C                   ENDIF

     C                   MOVEL     FNMCSV        #1MCYS
     C                   IF        FNMCOV = '  '
     C                   MOVE      '-'           #1MCYS
     C                   ELSE
     C                   MOVE      FNMCOV        #1MCYS
     C                   ENDIF

     C                   MOVEL     FNGCSV        #1GCDS
     C                   IF        FNGCOV = '  '
     C                   MOVE      '-'           #1GCDS
     C                   ELSE
     C                   MOVE      FNGCOV        #1GCDS
     C                   ENDIF

     C                   MOVEL     FNIDSV        #1IDNS
     C                   IF        FNIDOV = '  '
     C                   MOVE      '-'           #1IDNS
     C                   ELSE
     C                   MOVE      FNIDOV        #1IDNS
     C                   ENDIF

     C                   MOVEL     FNTXSV        #1TINS
     C                   IF        FNTXOV = '  '
     C                   MOVE      '-'           #1TINS
     C                   ELSE
     C                   MOVE      FNTXOV        #1TINS
     C                   ENDIF

     C                   MOVEL     FNRPSV        #1PINS
     C                   IF        FNRPOV = '  '
     C                   MOVE      '-'           #1PINS
     C                   ELSE
     C                   MOVE      FNRPOV        #1PINS
     C                   ENDIF

     C                   MOVEL     FNAUSV        #1AUTS
     C                   IF        FNAUOV = '  '
     C                   MOVE      '-'           #1AUTS
     C                   ELSE
     C                   MOVE      FNAUOV        #1AUTS
     C                   ENDIF

     C                   EVAL      DDSFRN = DDSFRN + 1
     C                   WRITE     SD000733S0

     C     KCustKey1     READE     SDFTNHL4
     C                   ENDDO

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadCSFile - Load Customers on the Subfile                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLoadCSFile  BEGSR

     C     KCustKey1     SETLL     SDFTCSL4
     C     KCustKey1     READE     SDFTCSL4

     C                   DOW       NOT %EOF(SDFTCSL4)

     C     FACUST        CHAIN     SDFCBKL0

     C                   IF        SDFTCS = SDFCBK
     C                             OR BCCUST = *BLANKS
     C     KCustKey1     READE     SDFTCSL4
     C                   ITER
     C                   ENDIF

      ** Check if Header needs to be redisplayed
     C                   IF        WLoadHead = 'N'
     C                   EXSR      SRLoadHead
     C                   EVAL      WLoadHead ='Y'
     C                   ENDIF

     C                   IF        WInitLoad = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WInitLoad ='N'
     C                   ENDIF

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FACUST        PKey1
     C                   PARM                    PKySt
     C     SDCUSD        PARM      SDCUSD        DSSDY

      ** Added check on BBTYLC <> 'D'
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD = '*NRF   '
     C                             AND BBTYLC <> 'D'
     C                   EVAL      DBFILE = 'SDCUSDPD'
     C                   EVAL      DBASE  = 003
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save the key of the previous record and the key of the current
      ** record to be display.

     C                   IF        KTYPSV <> KCTYP OR
     C                             KPCLSV <> KPCLS OR
     C                             KRTYPV <> KRTYP OR                                       MD027682
     C                             KCCLSV <> KCCLS

     C                   IF        WArrIndx = 2

     C                   EVAL      WArrIndx = 1
     C     WArrIndx      OCCUR     SAVKEY
     C                   EVAL      KTYPSV = KCTYP
     C                   EVAL      KPCLSV = KPCLS
     C                   EVAL      KCCLSV = KCCLS
     C                   EVAL      KRTYPV = KRTYP                                           MD027682

     C                   ELSE

     C                   EVAL      WArrIndx = WArrIndx + 1
     C     WArrIndx      OCCUR     SAVKEY
     C                   EVAL      KTYPSV = KCTYP
     C                   EVAL      KPCLSV = KPCLS
     C                   EVAL      KCCLSV = KCCLS
     C                   EVAL      KRTYPV = KRTYP                                           MD027682

     C                   ENDIF
     C                   ENDIF

     C                   EVAL      #1REFN =  FACUST
     C                   EVAL      #1RNAM =  BBCSSN

     C                   MOVEL     FACBSV        #1BTHS
     C                   IF        FACBOV = ' '
     C                   MOVE      '-'           #1BTHS
     C                   ELSE
     C                   MOVE      FACBOV        #1BTHS
     C                   ENDIF

     C                   MOVEL     FACDSV        #1DOMS
     C                   IF        FACDOV = ' '
     C                   MOVE      '-'           #1DOMS
     C                   ELSE
     C                   MOVE      FACDOV        #1DOMS
     C                   ENDIF

     C                   MOVEL     FATESV        #1TELS
     C                   IF        FATEOV = ' '
     C                   MOVE      '-'           #1TELS
     C                   ELSE
     C                   MOVE      FATEOV        #1TELS
     C                   ENDIF

     C                   MOVEL     FAHMSV        #1MALS
     C                   IF        FAHMOV = ' '
     C                   MOVE      '-'           #1MALS
     C                   ELSE
     C                   MOVE      FAHMOV        #1MALS
     C                   ENDIF

     C                   MOVEL     FACISV        #1CTZS
     C                   IF        FACIOV = ' '
     C                   MOVE      '-'           #1CTZS
     C                   ELSE
     C                   MOVE      FACIOV        #1CTZS
     C                   ENDIF

     C                   MOVEL     FAJASV        #1JACS
     C                   IF        FAJAOV = ' '
     C                   MOVE      '-'           #1JACS
     C                   ELSE
     C                   MOVE      FAJAOV        #1JACS
     C                   ENDIF

     C                   MOVEL     FAMCSV        #1MCYS
     C                   IF        FAMCOV = '  '
     C                   MOVE      '-'           #1MCYS
     C                   ELSE
     C                   MOVE      FAMCOV        #1MCYS
     C                   ENDIF

     C                   MOVEL     FAGCSV        #1GCDS
     C                   IF        FAGCOV = '  '
     C                   MOVE      '-'           #1GCDS
     C                   ELSE
     C                   MOVE      FAGCOV        #1GCDS
     C                   ENDIF

     C                   MOVEL     FAIDSV        #1IDNS
     C                   IF        FAIDOV = '  '
     C                   MOVE      '-'           #1IDNS
     C                   ELSE
     C                   MOVE      FAIDOV        #1IDNS
     C                   ENDIF

     C                   MOVEL     FATXSV        #1TINS
     C                   IF        FATXOV = '  '
     C                   MOVE      '-'           #1TINS
     C                   ELSE
     C                   MOVE      FATXOV        #1TINS
     C                   ENDIF

     C                   MOVEL     FARPSV        #1PINS
     C                   IF        FARPOV = '  '
     C                   MOVE      '-'           #1PINS
     C                   ELSE
     C                   MOVE      FARPOV        #1PINS
     C                   ENDIF

     C                   MOVEL     FAAUSV        #1AUTS
     C                   IF        FAAUOV = '  '
     C                   MOVE      '-'           #1AUTS
     C                   ELSE
     C                   MOVE      FAAUOV        #1AUTS
     C                   ENDIF

     C                   EVAL      DDSFRN = DDSFRN + 1
     C                   WRITE     SD000733S0

     C     KCustKey1     READE     SDFTCSL4
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitSFL  - Initialise Subfile                               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInitSFL     BEGSR

     C                   Z-ADD     0             DDSFRN
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SD000733C0
     C                   EVAL      *IN97 = *OFF

      ** Clear program message queue
     C                   CALL      'ZA0250'

     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRProcReport - Process Report                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRProcReport  BEGSR

     C                   OPEN      SD000733AU                                              MD027209C
     C                   EVAL      WOpenP1 = 'N'                                            MD027209
     C                   EVAL      WOpenP2 = 'N'                                            MD027209
     C                   EVAL      RCUST = 0                                                MD027209
     C                   EVAL      RNAHO = 0                                                MD027209
     C                   EXSR      SRProcCUSD
     C                   EXSR      SRProcNAHO
     C                   WRITE     CONTROL
     C                   CLOSE     SD000733AU                                              MD027209C

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

     C******LOVAL        SETLL     SDFTNHL4                                                 MD028682
     C**********         READ      SDFTNHL4                                                 MD028682

     C     *LOVAL        SETLL     SDFCLDL0                                                 MD028682
     C                   READ      SDFCLDL0                                                 MD028682
                                                                                            MD028682
     C                   DOW       NOT %EOF(SDFCLDL0)                                       MD028682
     C                   EVAL      KCTYP = DRFCTP                                           MD028682
     C                   EVAL      KPCLS = DRFCCD                                           MD028682
     C                   EVAL      KCCLS = DRFCD1                                           MD028682
     C                   EVAL      KRTYP = DRRTYP                                           MD027682
                                                                                            MD028682
     C     KCustKey1     SETLL     SDFTNHL4                                                 MD028682
     C     KCustKey1     READE     SDFTNHL4                                                 MD028682
     C                   DOW       NOT %EOF(SDFTNHL4)

     C     FNNAHO        CHAIN     SDFNBKL0

     C                   IF        SDFTNH = SDFNBK
     C                             OR BNNAHO = *BLANKS
     C**********         READ      SDFTNHL4                                                 MD028682
     C     KCustKey1     READE     SDFTNHL4                                                 MD028682
     C                   ITER
     C                   ENDIF

     C                   IF        WOpenP2 = 'N'
     C                   OPEN      SD000733P2
     C                   EVAL      WOpenP2 = 'Y'

     C                   Z-ADD     SFNUM2        ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ZSEQ
     C                   PARM      *BLANKS       ZENTY
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

      ** error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFile = 'ZSFILE'
     C                   EVAL      DBKEY = SFILE2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   WRITE     SD733P2R0
     C
     C                   EXSR      SrNAHOHead
     C                   EVAL      WNNHTY = FNNHTY
     C                   EVAL      WNPCLA = FNPCLA
     C                   EVAL      WNCLAC = FNCLAC
     C                   EVAL      WNRPTT = FNRPTT                                          MD027682
     C
     C                   ENDIF

      ** If record changed (New clas/prev clas)
      ** Print new  set of headers
     C                   IF        FNNHTY <> WNNHTY OR
     C                             FNPCLA <> WNPCLA OR
     C                             FNRPTT <> WNRPTT OR                                      MD027682
     C                             FNCLAC <> WNCLAC
     C
     C                   EVAL      WNNHTY = FNNHTY
     C                   EVAL      WNPCLA = FNPCLA
     C                   EVAL      WNCLAC = FNCLAC
     C                   EVAL      WNRPTT = FNRPTT                                          MD027682
     C
     C                   EVAL      WRqdLin = 8
     C                   IF        PrtLn2 + WRqdLin >= OflLn2
     C                   WRITE     SD733P2R0
     C                   ENDIF
     C                   EXSR      SrNAHOHead
     C                   ENDIF

      ** prepare detail data for printing

     C                   EXSR      SrNAHODetl

     C                   EVAL      WRqdLin = 1
      ** Check for overflow
     C                   IF        PrtLn2 + WRqdLin >= OflLn2

     C                   WRITE     SD733P2R0

      ** Change Report Header
     C                   EXSR      SrNAHOHead
     C                   EVAL      WNNHTY = FNNHTY
     C                   EVAL      WNPCLA = FNPCLA
     C                   EVAL      WNCLAC = FNCLAC
     C                   EVAL      WNRPTT = FNRPTT                                          MD027682
     C
     C                   ENDIF

      ** Write detail record to SD000733P2

     C                   WRITE     SD733P2R3

      ** Increment count of records for audit

     C                   EVAL      RNAHO = RNAHO + 1
     C**********         READ      SDFTNHL4                                                 MD028682
     C     KCustKey1     READE     SDFTNHL4                                                 MD028682

     C                   ENDDO

     C                   READ      SDFCLDL0                                                 MD028682
                                                                                            MD028682
     C                   ENDDO                                                              MD028682
                                                                                            MD028682
     C                   IF        WOpenP2 = 'Y'
     C                   EVAL      WRqdLin = 3
      ** Check for overflow
     C                   IF        PrtLn2 + WRqdLin >= OflLn2
     C                   WRITE     SD733P2R0
     C                   ENDIF

     C                   WRITE     SD733P2R4

     C                   CLOSE     SD000733P2
     C                   ENDIF

     C                   ENDSR

      **********************************************************************
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

     C******LOVAL        SETLL     SDFTCSL4                                                 MD028682
     C**********         READ      SDFTCSL4                                                 MD028682

     C     *LOVAL        SETLL     SDFCLDL0                                                 MD028682
     C                   READ      SDFCLDL0                                                 MD028682
                                                                                            MD028682
     C                   DOW       NOT %EOF(SDFCLDL0)                                       MD028682
     C                   EVAL      KCTYP = DRFCTP                                           MD028682
     C                   EVAL      KPCLS = DRFCCD                                           MD028682
     C                   EVAL      KCCLS = DRFCD1                                           MD028682
     C                   EVAL      KRTYP = DRRTYP                                           MD027682
                                                                                            MD028682
     C     KCustKey1     SETLL     SDFTCSL4                                                 MD028682
     C     KCustKey1     READE     SDFTCSL4                                                 MD028682
     C                   DOW       NOT %EOF(SDFTCSL4)

     C     FACUST        CHAIN     SDFCBKL0

     C                   IF        SDFTCS = SDFCBK
     C                             OR BCCUST = *BLANKS
     C**********         READ      SDFTCSL4                                                 MD028682
     C     KCustKey1     READE     SDFTCSL4                                                 MD028682
     C                   ITER
     C                   ENDIF

     C                   IF        WOpenP1 = 'N'
     C                   OPEN      SD000733P1
     C                   EVAL      WOpenP1 = 'Y'

     C                   Z-ADD     SFNUM1        ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ZSEQ
     C                   PARM      *BLANKS       ZENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

      ** error during ZSFILE processing, return to calling program

     C                   IF        ZSERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFile = 'ZSFILE'
     C                   EVAL      DBKEY = SFILE1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   WRITE     SD733P1R0
     C
     C                   EXSR      SrCUSDHead
     C                   EVAL      WNNHTY = FACSTY
     C                   EVAL      WNPCLA = FAPCLA
     C                   EVAL      WNCLAC = FACLAC
     C                   EVAL      WNRPTT = FARPTT                                          MD027682
     C
     C                   ENDIF

      ** If record changed (New clas/prev clas)
      ** Print new  set of headers
     C                   IF        FACSTY <> WNNHTY OR
     C                             FAPCLA <> WNPCLA OR
     C                             FACLAC <> WNCLAC
     C                             OR FARPTT <> WNRPTT                                      MD027682
     C
     C                   EVAL      WNNHTY = FACSTY
     C                   EVAL      WNPCLA = FAPCLA
     C                   EVAL      WNCLAC = FACLAC
     C                   EVAL      WNRPTT = FARPTT                                          MD027682
     C
     C                   EVAL      WRqdLin = 8
     C                   IF        PrtLn1 + WRqdLin >= OflLn1
     C                   WRITE     SD733P1R0
     C                   ENDIF
     C                   EXSR      SrCUSDHead
     C                   ENDIF

      ** prepare detail data for printing

     C                   EXSR      SrCUSDDetl

     C                   EVAL      WRqdLin = 1
      ** Check for overflow
     C                   IF        PrtLn1 + WRqdLin >= OflLn1

     C                   WRITE     SD733P1R0

      ** Change Report Header
     C                   EXSR      SrCUSDHead
     C                   EVAL      WNNHTY = FACSTY
     C                   EVAL      WNPCLA = FAPCLA
     C                   EVAL      WNCLAC = FACLAC
     C                   EVAL      WNRPTT = FARPTT                                          MD027682
     C
     C                   ENDIF

      ** Write detail record to SD000733P1

     C                   WRITE     SD733P1R3

      ** Increment count of records for audit

     C                   EVAL      RCUST = RCUST + 1
     C**********         READ      SDFTCSL4                                                 MD028682
     C     KCustKey1     READE     SDFTCSL4                                                 MD028682

     C                   ENDDO

     C                   READ      SDFCLDL0                                                 MD028682
                                                                                            MD028682
     C                   ENDDO                                                              MD028682
                                                                                            MD028682
     C                   IF        WOpenP1 = 'Y'
     C                   EVAL      WRqdLin = 3
      ** Check for overflow
     C                   IF        PrtLn1 + WRqdLin >= OflLn1
     C                   WRITE     SD733P1R0
     C                   ENDIF

     C                   WRITE     SD733P1R4

     C                   CLOSE     SD000733P1
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNAHODetl  - Detail Line for NAHO Reporting                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrNAHODetl    BEGSR

     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    FNNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE  = 003
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RIDEN   = FNNAHO
     C                   EVAL      RRNAM   = NHNARN
     C                   EVAL      RCBRTS  = FNCBSV
     C                   EVAL      RCBRTO  = FNCBOV
     C                   EVAL      RCDCLS  = FNCDSV
     C                   EVAL      RCDCLO  = FNCDOV
     C                   EVAL      RTELNS  = FNTESV
     C                   EVAL      RTELNO  = FNTEOV
     C                   EVAL      RMAILS  = FNHMSV
     C                   EVAL      RMAILO  = FNHMOV
     C                   EVAL      RCTZNS  = FNCISV
     C                   EVAL      RCTZNO  = FNCIOV
     C                   EVAL      RJACCS  = FNJASV
     C                   EVAL      RJACCO  = FNJAOV
     C                   EVAL      RADDRS  = FNMCSV
     C                   EVAL      RADDRO  = FNMCOV
     C                   EVAL      RGCARDS = FNGCSV
     C                   EVAL      RGCARDO = FNGCOV
     C                   EVAL      RIDENS  = FNIDSV
     C                   EVAL      RIDENO  = FNIDOV
     C                   EVAL      RTINS   = FNTXSV
     C                   EVAL      RTINO   = FNTXOV
     C                   EVAL      RPINSTS = FNRPSV
     C                   EVAL      RPINSTO = FNRPOV
     C                   EVAL      RAUTHS  = FNAUSV
     C                   EVAL      RAUTHO  = FNAUOV

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCUSDDetl  - Detail Line for NAHO Reporting                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCUSDDetl    BEGSR

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FACUST        PKey1
     C                   PARM                    PKySt
     C     SDCUSD        PARM      SDCUSD        DSSDY

      ** Added check on BBTYLC <> 'D'
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD = '*NRF   '
     C                             AND BBTYLC <> 'D'
     C                   EVAL      DBFILE = 'SDCUSDPD'
     C                   EVAL      DBASE  = 003
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RIDEN   = FACUST
     C                   EVAL      RRNAM   = BBCSSN
     C                   EVAL      RCBRTS  = FACBSV
     C                   EVAL      RCBRTO  = FACBOV
     C                   EVAL      RCDCLS  = FACDSV
     C                   EVAL      RCDCLO  = FACDOV
     C                   EVAL      RTELNS  = FATESV
     C                   EVAL      RTELNO  = FATEOV
     C                   EVAL      RMAILS  = FAHMSV
     C                   EVAL      RMAILO  = FAHMOV
     C                   EVAL      RCTZNS  = FACISV
     C                   EVAL      RCTZNO  = FACIOV
     C                   EVAL      RJACCS  = FAJASV
     C                   EVAL      RJACCO  = FAJAOV
     C                   EVAL      RADDRS  = FAMCSV
     C                   EVAL      RADDRO  = FAMCOV
     C                   EVAL      RGCARDS = FAGCSV
     C                   EVAL      RGCARDO = FAGCOV
     C                   EVAL      RIDENS  = FAIDSV
     C                   EVAL      RIDENO  = FAIDOV
     C                   EVAL      RTINS   = FATXSV
     C                   EVAL      RTINO   = FATXOV
     C                   EVAL      RPINSTS = FARPSV
     C                   EVAL      RPINSTO = FARPOV
     C                   EVAL      RAUTHS  = FAAUSV
     C                   EVAL      RAUTHO  = FAAUOV

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNAHOHead  - Header Line for NAHO Reporting                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrNAHOHead    BEGSR

     C                   SELECT
     C                   WHEN      FNNHTY = 'F'
     C                   EVAL      RTYPE   = 'Foreign Financial Institution'
     C                   WHEN      FNNHTY = 'N'
     C                   EVAL      RTYPE   = 'Non-Financial Entity'
     C                   WHEN      FNNHTY = 'P'
     C                   EVAL      RTYPE   = 'Physical Person'
     C                   WHEN      FNNHTY = 'J'
     C                   EVAL      RTYPE   = 'Joint Account'
     C                   WHEN      FNNHTY = 'O'
     C                   EVAL      RTYPE   = 'Others'
     C                   ENDSL

     C                   EVAL      RPCLA   = FNPCLA

     C                   CALL      'AOFATCR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      FNPCLA        PCLAS
     C                   PARM                    SDFATC

     C                   EVAL      RPDSC   = FCDESC

     C                   EVAL      RCLAC   = FNCLAC

     C                   CALL      'AOFATCR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      FNCLAC        PCLAS
     C                   PARM                    SDFATC

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDFATCPD'
     C                   EVAL      DBASE  = 004
     C                   EVAL      DBKEY  = PCLAS
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RDESC   = FCDESC

     C                   SELECT
     C                   WHEN      FNRPTT = 'R'
     C                   EVAL      RRTYP  = 'Recalcitrant'
     C                   WHEN      FNRPTT = 'C'
     C                   EVAL      RRTYP  = 'Consent Received'
     C                   WHEN      FNRPTT = 'P'
     C                   EVAL      RRTYP  = 'Pending'
     C                   WHEN      FNRPTT = 'N'
     C                   EVAL      RRTYP  = 'Not Relevant'
     C                   OTHER
     C                   EVAL      RRTYP  = 'Unknown'
     C                   ENDSL

     C                   WRITE     SD733P2R1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCUSDHead  - Header Line for CUST Reporting                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCUSDHead    BEGSR

     C                   SELECT
     C                   WHEN      FACSTY = 'F'
     C                   EVAL      RTYPE   = 'Foreign Financial Institution'
     C                   WHEN      FACSTY = 'N'
     C                   EVAL      RTYPE   = 'Non-Financial Entity'
     C                   WHEN      FACSTY = 'P'
     C                   EVAL      RTYPE   = 'Physical Person'
     C                   WHEN      FACSTY = 'J'
     C                   EVAL      RTYPE   = 'Joint Account'
     C                   WHEN      FACSTY = 'O'
     C                   EVAL      RTYPE   = 'Others'
     C                   ENDSL

     C                   EVAL      RPCLA   = FAPCLA

     C                   CALL      'AOFATCR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      FAPCLA        PCLAS
     C                   PARM                    SDFATC

     C                   EVAL      RPDSC   = FCDESC

     C                   EVAL      RCLAC   = FACLAC

     C                   CALL      'AOFATCR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      FACLAC        PCLAS
     C                   PARM                    SDFATC

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDFATCPD'
     C                   EVAL      DBASE  = 004
     C                   EVAL      DBKEY  = PCLAS
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RDESC   = FCDESC

     C                   SELECT
     C                   WHEN      FARPTT = 'R'
     C                   EVAL      RRTYP  = 'Recalcitrant'
     C                   WHEN      FARPTT = 'C'
     C                   EVAL      RRTYP  = 'Consent Received'
     C                   WHEN      FARPTT = 'P'
     C                   EVAL      RRTYP  = 'Pending'
     C                   WHEN      FARPTT = 'N'
     C                   EVAL      RRTYP  = 'Not Relevant'
     C                   OTHER
     C                   EVAL      RRTYP  = 'Unknown'
     C                   ENDSL

     C                   WRITE     SD733P1R1
     C                   WRITE     SD733P1R2

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadHead - Load Header details during Enquiry Process       *
      *                                                               *
      * Called by: SRProcEnquiry                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrLoadHead    BEGSR

     C                   EXSR      SRInitSFL
      *
      ** FATCA Customer Type
      *
     C                   SELECT
     C                   WHEN      DRFCTP = 'F'
     C                   EVAL      DDCTYP  = 'Foreign Financial Institution'
     C                   WHEN      DRFCTP = 'N'
     C                   EVAL      DDCTYP  = 'Non-Financial Entity'
     C                   WHEN      DRFCTP = 'P'
     C                   EVAL      DDCTYP  = 'Physical Person'
     C                   WHEN      DRFCTP = 'J'
     C                   EVAL      DDCTYP  = 'Joint Account'
     C                   WHEN      DRFCTP = 'O'
     C                   EVAL      DDCTYP  = 'Others'
     C                   ENDSL

      ** FATCA Current Classification Code and Description
     C                   EVAL      DDPCLA = DRFCCD

     C                   CALL      'AOFATCR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DRFCCD        PCLAS
     C                   PARM                    SDFATC
     C                   EVAL      DDPCLD = FCDESC

      ** FATCA Prev Current Classification Code and Description
     C                   EVAL      DDCLAC = DRFCD1

     C                   CALL      'AOFATCR0'
     C                   PARM                    PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DRFCD1        PCLAS
     C                   PARM                    SDFATC
     C                   EVAL      DDCLAD = FCDESC

      ** FATCA Reporting Type
     C                   SELECT
     C                   WHEN      DRRTYP = 'R'
     C                   EVAL      DDRTYP = 'Recalcitrant'
     C                   WHEN      DRRTYP = 'C'
     C**********         EVAL      RRTYP  = 'Consent Received'                              MD027682
     C                   EVAL      DDRTYP  = 'Consent Received'                             MD027682
     C                   WHEN      DRRTYP = 'P'
     C                   EVAL      DDRTYP = 'Pending'
     C                   WHEN      DRRTYP = 'N'
     C                   EVAL      DDRTYP = 'Not Relevant'
     C                   OTHER
     C                   EVAL      DDRTYP = 'Unknown'
     C                   ENDSL

      ** Update key List
     C                   EVAL      KCTYP = DRFCTP
     C                   EVAL      KPCLS = DRFCCD
     C                   EVAL      KCCLS = DRFCD1

     C                   EVAL      HCTYP = DRFCTP                                           MD027209
     C                   EVAL      HPCLS = DRFCCD                                           MD027209
     C                   EVAL      HCCLS = DRFCD1                                           MD027209
     C                   EVAL      HCRTP = DRRTYP                                           MD027209
                                                                                            MD027209
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInitialise - Initial subroutine                             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrInitialise  BEGSR

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrepDrive  - Prepare Driving File                           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrPrepDrive   BEGSR

      ** Read through Criterion of Indicia Found
     C     *LOVAL        SETLL     SDFCL1L0
     C                   READ      SDFCL1L0

     C                   DOW       NOT %EOF(SDFCL1L0)
                                                                                            MD027498
      ** If New Class is Blanks, this means no changes should happen                        MD027498
      ** Need to collect all possible 'previous' class                                      MD027498
     C                   IF        DPFCD1 = *BLANKS                                         MD027498
                                                                                            MD027498
     C     *LOVAL        SETLL     SDFATCL0                                                 MD027498
     C                   READ      SDFATCL0                                                 MD027498
                                                                                            MD027498
     C                   DOU       %EOF(SDFATCL0)                                           MD027498
     C                   EVAL      DRFCCD = FCCODE                                          MD027498
     C                   EVAL      DRFCTP = DPFCTP                                          MD027498
     C**********         EVAL      DRRTYP = DPRTYP                                 MD027498 MD027682
     C                   EVAL      DRFCD1 = DPFCCD                                          MD027498
                                                                                            MD027682
      ** Generate Record with all possibles value of reporting type                         MD027682
                                                                                            MD027682
     C                   EVAL      RepTypIdx = 1                                            MD027682
     C                   DOU       RepTypIdx > MaxType                                      MD027682
     C                   EVAL      DRRTYP = RtypVal(RepTypIdx)                              MD027682
     C                   EVAL      RepTypIdx = RepTypIdx + 1                                MD027682
     C                   WRITE     SDFCLDD0                                                 MD027498
     C                   ENDDO                                                              MD027682
                                                                                            MD027682
     C                   READ      SDFATCL0                                                 MD027498
     C                   ENDDO                                                              MD027498
                                                                                            MD027498
     C                   READ      SDFCL1L0                                                 MD027498
     C                   ITER                                                               MD027498
                                                                                            MD027498
     C                   ENDIF                                                              MD027498
                                                                                            MD027498
     C                   EVAL      DRFCCD = DPFCCD
     C                   EVAL      DRFCTP = DPFCTP
     C**********         IF        DPFCD1 = *BLANKS                                         MD027498
     C**********         EVAL      DRFCD1 = DPFCCD                                          MD027498
     C**********         ELSE                                                               MD027498
     C                   EVAL      DRFCD1 = DPFCD1
     C**********         ENDIF                                                              MD027498
     C**********         EVAL      DRRTYP = DPRTYP                                          MD027682
                                                                                            MD027682
      ** Generate Record with all possible values of reporting type                         MD027682
     C                   EVAL      RepTypIdx = 1                                            MD027682
     C                   DOU       RepTypIdx > MaxType                                      MD027682
     C                   EVAL      DRRTYP = RtypVal(RepTypIdx)                              MD027682
     C                   EVAL      RepTypIdx = RepTypIdx + 1                                MD027682
     C                   WRITE     SDFCLDD0
     C                   ENDDO                                                              MD027682
                                                                                            MD027682
     C                   READ      SDFCL1L0
     C                   ENDDO

      ** Read through Criterion of Indicia Not Found
     C     *LOVAL        SETLL     SDFCL1L1
     C                   READ      SDFCL1L1

     C                   DOW       NOT %EOF(SDFCL1L1)
                                                                                            MD027498
      ** If New Class is Blanks, this means no changes should happen                        MD027498
      ** Need to collect all possible 'previous' class                                      MD027498
     C                   IF        DPFCD2 = *BLANKS                                         MD027498
                                                                                            MD027498
     C     *LOVAL        SETLL     SDFATCL0                                                 MD027498
     C                   READ      SDFATCL0                                                 MD027498
                                                                                            MD027498
     C                   DOU       %EOF(SDFATCL0)                                           MD027498
     C                   EVAL      RepTypIdx = 1                                            MD027682
     C                   DOU       RepTypIdx > MaxType                                      MD027682
     C                   EVAL      KRRTYP = RtypVal(RepTypIdx)                              MD027682
     C                   EVAL      KRFCCD = FCCODE                                          MD027498
     C                   EVAL      KRFCTP = DPFCTP                                          MD027498
     C                   EVAL      KRFCD1 = DPFCCD                                          MD027498
     C**********         EVAL      KRRTYP = DPRTYP                                 MD027498 MD027682
     C                   EVAL      KRRTYP = RtypVal(RepTypIdx)                              MD027682
                                                                                            MD027682
      ** Generate Record with all possibles value of reporting type                         MD027682
                                                                                            MD027682
                                                                                            MD027498
      ** Check if combination already exists in the driving file                            MD027498
     C     KDrvrChk      CHAIN     SDFCLDL0                                                 MD027498
                                                                                            MD027498
     C                   IF        NOT %FOUND(SDFCLDL0)                                     MD027498
     C                   EVAL      DRFCCD = FCCODE                                          MD027498
     C                   EVAL      DRFCTP = DPFCTP                                          MD027498
     C**********         EVAL      DRRTYP = DPRTYP                                 MD027498 MD027682
     C                   EVAL      DRRTYP = RtypVal(RepTypIdx)                              MD027682
     C                   EVAL      DRFCD1 = DPFCCD                                          MD027498
     C                   WRITE     SDFCLDD0                                                 MD027498
     C                   ENDIF                                                              MD027498
     C                   EVAL      RepTypIdx = RepTypIdx + 1                                MD027682
     C                   ENDDO                                                              MD027682
                                                                                            MD027498
     C                   READ      SDFATCL0                                                 MD027498
     C                   ENDDO                                                              MD027498
                                                                                            MD027498
     C**********         READ      SDFCL1L0                                                 MD027498
     C                   READ      SDFCL1L1                                       MD027498 MD027498A
     C                   ITER                                                               MD027498
                                                                                            MD027498
     C                   ENDIF                                                              MD027498

     C                   EVAL      KRFCCD = DPFCCD
     C                   EVAL      KRFCTP = DPFCTP
     C                   IF        DPFCD1 = *BLANKS
     C                   EVAL      KRFCD1 = DPFCCD
     C                   ELSE
     C                   EVAL      KRFCD1 = DPFCD2
     C                   ENDIF
     C**********         EVAL      KRRTYP = DPRTYP                                          MD027682
                                                                                            MD027682
      ** Generate Record with all possibles value of reporting type                         MD027682
                                                                                            MD027682
     C                   EVAL      RepTypIdx = 1                                            MD027682
     C                   DOU       RepTypIdx > MaxType                                      MD027682
     C                   EVAL      KRRTYP = RtypVal(RepTypIdx)                              MD027682
      ** Check if combination already exists in the driving file
     C     KDrvrChk      CHAIN     SDFCLDL0

     C                   IF        NOT %FOUND(SDFCLDL0)
     C                   EVAL      DRFCCD = KRFCCD
     C                   EVAL      DRFCTP = KRFCTP
     C                   EVAL      DRFCD1 = KRFCD1
     C**********         EVAL      DRRTYP = KRRTYP                                          MD027682
     C                   EVAL      DRRTYP = RtypVal(RepTypIdx)                              MD027682
     C                   WRITE     SDFCLDD0
     C                   ENDIF
     C                   EVAL      RepTypIdx = RepTypIdx + 1                                MD027682
     C                   ENDDO                                                              MD027682

     C                   READ      SDFCL1L1
     C                   ENDDO

     C                   ENDSR

      **********************************************************************
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

     C     *ENTRY        PLIST
     C                   PARM                    PMode

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY

      ** Database error

     C     PRetCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RRRUNA = BJMRDT

     C     KCustKey      KLIST
     C                   KFLD                    KCTYP
     C                   KFLD                    KPCLS
     C                   KFLD                    KCCLS
     C                   KFLD                    KCNUM

     C     KCustKey1     KLIST
     C                   KFLD                    KCTYP
     C                   KFLD                    KPCLS
     C                   KFLD                    KCCLS
     C                   KFLD                    KRTYP                                      MD027682

     C     KNAHOKey      KLIST
     C                   KFLD                    KCTYP
     C                   KFLD                    KPCLS
     C                   KFLD                    KCCLS
     C                   KFLD                    KNAHO

     C     KNAHOKey1     KLIST
     C                   KFLD                    KCTYP
     C                   KFLD                    KPCLS
     C                   KFLD                    KCCLS

     C     KDrvrChk      KLIST
     C                   KFLD                    KRFCTP
     C                   KFLD                    KRFCCD
     C                   KFLD                    KRFCD1
     C                   KFLD                    KRRTYP

     C                   IF        PMode = 'I'
     C                   EVAL      *IN70 = *ON
     C                   ELSE
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF

     C                   EVAL      RNAHO = 0
     C                   EVAL      RCUST = 0

     C                   EVAL      DDWID  = PsJobName
     C                   EVAL      DDPGMQ = PSProcName
     C                   EVAL      DDUSER = PsUser
     C                   EVAL      *IN78 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      WPageCtr = 0

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
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**CTDATA TYPEARR
F(FFI)
N(NFE)
J(Joint Account)
P(Physical Person)
O(Other)
**CTDATA RtypVal
C
N
P
R
U
