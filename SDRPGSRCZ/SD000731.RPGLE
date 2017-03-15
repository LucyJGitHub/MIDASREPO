     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Indicia Search Tool Staging Module')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000731 - FATCA US Indicia Search Tool                      *
      *                                                               *
      *  Function:  This module updates all FATCA Customers with      *
      *             US Indicia                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD039670           Date 26Jul16               *
      *  Prev Amend No. MD034067           Date 13Jul15               *
      *                 MD027682           Date 28Aug14               *
      *                 MD027669           Date 01Jul14               *
      *                 MD027498           Date 20Jun14               *
      *                 MD027315           Date 06Jun14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  MD034067 - Customer with joint account indicia is wrongly    *
      *             classified by the US indicia tool as without US   *
      *             indicia (Apply Fix MD027669)                      *
      *  MD027682 - Reporting Type is not Reflected During Information*
      *             and Update Mode in USIT                           *
      *  MD027669 - Joint Account Principal Wrongly classified        *
      *             by the tool                                       *
      *  MD027498 - Inconsistent behaviour of setting New             *
      *             Classification Code in selection criteria to blank*
      *  MD027315 - Classification changed during info mode error     *
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
     FSDFATCL0  IF   E           K DISK    INFSR(*PSSR)
 
     FSDFCLSL0  UF A E           K DISK    INFSR(*PSSR)
 
     FSDFCLSL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCLSD0:SDFCLSD1)
 
     FSDFCLSL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCLSD0:SDFCLSD2)
 
     FSDFTNHL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTNHD0:SDFTNHD3)
 
     FSDFTCSL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTCSD0:SDFTCSD3)
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
 
     DArrayMax         C                   CONST(999)
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
     DCtryCodeArr      S              2    DIM(ArrayMax)
 
      ** Run-time Array for FATCA Classitfication codes
     DClassArr         S              5A   DIM(ArrayMax)
 
      ** Run-time Array for FATCA Customer Types
     DTypeArr          S              1A   DIM(MaxType)
     D                                     CTDATA
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for Non-Account                                        MD039670
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                            MD039670
                                                                                        MD039670
 
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
     D PClasIF         S              5A
     D PClasNF         S              5A
     D PRepType        S              1A
     D PMode           S              1A
 
     D PRetCode        S              7A
     D POption         S             10A
     D WTFCCD          S              5A
     D WTFCTP          S              1A
     D WTFCD1          S              5A
     D WTFCD2          S              5A
     D Wupdat          S              1A                                                    MD027315
     D PRTCD           S              7                                                     MD039670
     D POPTN           S              7                                                     MD039670
     D PKEY1           S             10                                                     MD039670
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
 
     C                   EXSR      SRInitialise
 
     C                   EVAL      PMode = 'M'                                              MD027669
      ** Identify all Classification Code changes
     C                   IF        WCardF = '*'
 
     C     *LOVAL        SETLL     SDFATCL0
     C                   READ      SDFATCL0
     C                   EVAL      KCode = FCCODE
     C                   EVAL      WTypeI = 1
     C                   EVAL      KCType = TypeArr(WTypeI)
 
     C**********         DOW       WTypeI < MaxType                                         MD027682
     C                   DOW       WTypeI <= MaxType                                        MD027682
     C                   EXSR      SRProcNAHO
     C                   EXSR      SRProcCUSD
     C                   EVAL      WTypeI = WTypeI + 1
     C                   EVAL      KCType = TypeArr(WTypeI)
     C                   ENDDO
 
     C                   ELSE
 
     C     *LOVAL        SETLL     SDFCLSL0
     C                   READ(N)   SDFCLSL0
     C                   EVAL      KCode = DPFCCD
     C                   EVAL      KCType = DPFCTP
 
     C                   ENDIF
 
     C                   DOU       %EOF(SDFATCL0)
     C                             AND WCardF = '*'
     C                             OR %EOF(SDFCLSL0)
     C                   EXSR      SRProcNAHO
 
     C                   EXSR      SRProcCUSD
 
     C                   IF        WCardF = '*'
     C                   READ      SDFATCL0
     C                   EVAL      KCode = FCCODE
     C                   EVAL      WTypeI = 1
     C                   EVAL      KCType = TypeArr(WTypeI)
 
     C**********         DOW       WTypeI < MaxType                                         MD027682
     C                   DOW       WTypeI <= MaxType                                        MD027682
     C                   EXSR      SRProcNAHO
     C                   EXSR      SRProcCUSD
     C                   EVAL      WTypeI = WTypeI + 1
     C                   EVAL      KCType = TypeArr(WTypeI)
     C                   ENDDO
 
     C                   ELSE
     C                   READ(N)   SDFCLSL0
     C                   EVAL      KCode = DPFCCD
     C                   EVAL      KCType = DPFCTP
     C                   ENDIF
 
     C                   ENDDO
 
     C**********         IF        DPFCD1 <> *BLANKS                                        MD027498
     C                   EVAL      PClasIF = DPFCD1
     C**********         ELSE                                                               MD027498
     C**********         EVAL      PClasIF = DPFCCD                                         MD027498
     C**********         ENDIF                                                              MD027498
 
     C**********         IF        DPFCD2 <> *BLANKS                                        MD027498
     C                   EVAL      PClasNF = DPFCD2
     C**********         ELSE                                                               MD027498
     C**********         EVAL      PClasNF = DPFCCD                                         MD027498
     C**********         ENDIF                                                              MD027498
 
     C                   EVAL      PReturn = *BLANKS                                        MD027315
     C                   IF        Wupdat = 'Y'                                             MD027315
     C                   EVAL      PReturn = 'UPDAT'                                        MD027315
     C                   ENDIF                                                              MD027315
                                                                                            MD027315
      ** Initiate Joint Account check over all records
     C                   CALL      'SD000732'
     C**********         PARM      *BLANKS       PReturn                                    MD027315
     C                   PARM                    PReturn                                    MD027315
     C                   PARM                    PTranID
     C                   PARM      'J'           PSource
     C                   PARM                    PClasIF
     C                   PARM                    PClasNF
     C                   PARM      ' '           PRepType
     C**********         PARM                    PMode                                      MD024755
     C                   PARM      'M'           PMode                                      MD024755
 
      ** Identify all Classification Code changes for                                       MD027669
      ** Classification Run                                                                 MD027669
     C                   EVAL      PMode = 'C'                                              MD027669
     C                   IF        WCardF = '*'                                             MD027669
                                                                                            MD027669
     C     *LOVAL        SETLL     SDFATCL0                                                 MD027669
     C                   READ      SDFATCL0                                                 MD027669
     C                   EVAL      KCode = FCCODE                                           MD027669
     C                   EVAL      WTypeI = 1                                               MD027669
     C                   EVAL      KCType = TypeArr(WTypeI)                                 MD027669
                                                                                            MD027669
     C**********         DOW       WTypeI < MaxType                                MD027669 MD027682
     C                   DOW       WTypeI <= MaxType                                        MD027682
     C                   EXSR      SRProcNAHO                                               MD027669
     C                   EXSR      SRProcCUSD                                               MD027669
     C                   EVAL      WTypeI = WTypeI + 1                                      MD027669
     C                   EVAL      KCType = TypeArr(WTypeI)                                 MD027669
     C                   ENDDO                                                              MD027669
                                                                                            MD027669
     C                   ELSE                                                               MD027669
                                                                                            MD027669
     C     *LOVAL        SETLL     SDFCLSL0                                                 MD027669
     C                   READ(N)   SDFCLSL0                                                 MD027669
     C                   EVAL      KCode = DPFCCD                                           MD027669
     C                   EVAL      KCType = DPFCTP                                          MD027669
                                                                                            MD027669
     C                   ENDIF                                                              MD027669
                                                                                            MD027669
     C                   DOU       %EOF(SDFATCL0)                                           MD027669
     C                             AND WCardF = '*'                                         MD027669
     C                             OR %EOF(SDFCLSL0)                                        MD027669
     C                   EXSR      SRProcNAHO                                               MD027669
                                                                                            MD027669
     C                   EXSR      SRProcCUSD                                               MD027669
                                                                                            MD027669
     C                   IF        WCardF = '*'                                             MD027669
     C                   READ      SDFATCL0                                                 MD027669
     C                   EVAL      KCode = FCCODE                                           MD027669
     C                   EVAL      WTypeI = 1                                               MD027669
     C                   EVAL      KCType = TypeArr(WTypeI)                                 MD027669
                                                                                            MD027669
     C**********         DOW       WTypeI < MaxType                                MD027669 MD027682
     C                   DOW       WTypeI <= MaxType                                        MD027682
     C                   EXSR      SRProcNAHO                                               MD027669
     C                   EXSR      SRProcCUSD                                               MD027669
     C                   EVAL      WTypeI = WTypeI + 1                                      MD027669
     C                   EVAL      KCType = TypeArr(WTypeI)                                 MD027669
     C                   ENDDO                                                              MD027669
                                                                                            MD027669
     C                   ELSE                                                               MD027669
     C                   READ(N)   SDFCLSL0                                                 MD027669
     C                   EVAL      KCode = DPFCCD                                           MD027669
     C                   EVAL      KCType = DPFCTP                                          MD027669
     C                   ENDIF                                                              MD027669
                                                                                            MD027669
     C                   ENDDO                                                              MD027669
                                                                                            MD027669
     C                   SETON                                        LR
     C                   RETURN
 
 
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
 
     C     KClassKey     SETLL     SDFTNHL3
     C     KClassKey     READE     SDFTNHL3
 
     C                   DOW       NOT %EOF(SDFTNHL3)
                                                                                            MD039670
     C                   EVAL      PKEY1 = FNNAHO                                           MD039670
     C                   IF        PKEY1 <> *BLANKS                                         MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *Blanks       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PKEY1                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDFTNHL3                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD039670
 
     C**********         IF        DPFCD1 <> *BLANKS                                        MD027498
     C                   EVAL      PClasIF = DPFCD1
     C**********         ELSE                                                               MD027498
     C**********         EVAL      PClasIF = DPFCCD                                         MD027498
     C**********         ENDIF                                                              MD027498
 
     C**********         IF        DPFCD2 <> *BLANKS                                        MD027498
     C                   EVAL      PClasNF = DPFCD2
     C**********         ELSE                                                               MD027498
     C**********         EVAL      PClasNF = DPFCCD                                         MD027498
     C**********         ENDIF                                                              MD027498
 
     C                   EVAL      PReturn = *BLANKS                                        MD027315
     C                   IF        Wupdat = 'Y'                                             MD027315
     C                   EVAL      PReturn = 'UPDAT'                                        MD027315
     C                   ENDIF                                                              MD027315
                                                                                            MD027315
     C                   CALL      'SD000732'
     C**********         PARM      *BLANKS       PReturn                                    MD027315
     C                   PARM                    PReturn                                    MD027315
     C                   PARM      FNNAHO        PTranID
     C                   PARM      'N'           PSource
     C                   PARM                    PClasIF
     C                   PARM                    PClasNF
     C                   PARM      DPRTYP        PRepType
     C**********         PARM      'M'           PMode                                      MD027669
     C                   PARM                    PMode                                      MD027669
 
     C     KClassKey     READE     SDFTNHL3
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcCUST  - Process Customers' Indicia                      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrProcCUSD    BEGSR
 
     C     KClassKey     SETLL     SDFTCSL3
     C     KClassKey     READE     SDFTCSL3
 
     C                   DOW       NOT %EOF(SDFTCSL3)
 
     C**********         IF        DPFCD1 <> *BLANKS                                        MD027498
     C                   EVAL      PClasIF = DPFCD1
     C**********         ELSE                                                               MD027498
     C**********         EVAL      PClasIF = DPFCCD                                         MD027498
     C**********         ENDIF                                                              MD027498
 
     C**********         IF        DPFCD2 <> *BLANKS                                        MD027498
     C                   EVAL      PClasNF = DPFCD2
     C**********         ELSE                                                               MD027498
     C**********         EVAL      PClasNF = DPFCCD                                         MD027498
     C**********         ENDIF                                                              MD027498
 
     C                   EVAL      PReturn = *BLANKS                                        MD027315
     C                   IF        Wupdat = 'Y'                                             MD027315
     C                   EVAL      PReturn = 'UPDAT'                                        MD027315
     C                   ENDIF                                                              MD027315
                                                                                            MD027315
     C                   CALL      'SD000732'
     C**********         PARM      *BLANKS       PReturn                                    MD027315
     C                   PARM                    PReturn                                    MD027315
     C                   PARM      FACUST        PTranID
     C                   PARM      'C'           PSource
     C                   PARM                    PClasIF
     C                   PARM                    PClasNF
     C                   PARM      DPRTYP        PRepType
     C**********         PARM      'M'           PMode                                      MD027669
     C                   PARM                    PMode                                      MD027669
 
     C     KClassKey     READE     SDFTCSL3
 
     C                   ENDDO
 
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
 
     C                   EXSR      SrValInput
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValInput - Validate selection from prompt                   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrValInput    BEGSR
 
     C     *LOVAL        SETLL     SDFCLSL0                                                 
      ** Loop though the Prompt input
     C                   DOU       %EOF(SDFCLSL0)
 
      ** Read selection and filter out records
     C                   READ      SDFCLSL0
 
     C                   IF        DPFCCD =  '*ALL  ' AND
     C                             DPFCTP =  '*'
 
      ** If all records needs to be processed, flag and leave routine
     C                   EVAL      WCardF = 'M'
     C                   DELETE    SDFCLSD0
      *
      ** Prepare data for 'ALL' category
      *
     C     *LOVAL        SETLL     SDFATCL0
     C                   READ      SDFATCL0
      *
      ** Loop though the Prompt input
      *
     C                   DOU       %EOF(SDFATCL0)
      *
      ** Read selection and filter out records
      *
     C                   EVAL      DPFCCD = FCCODE
      *
     C                   EVAL      WTypeI = 1
      *
     C**********         DOU       WTypeI = MaxType                                         MD027682
     C                   DOU       WTypeI > MaxType                                         MD027682
     C                   EVAL      DPFCTP = TypeArr(WTypeI)
     C                   EVAL      WTypeI = WTypeI + 1
     C                   WRITE     SDFCLSD0
      *
     C                   ENDDO
      *
     C                   READ      SDFATCL0
      *
     C                   ENDDO
      *
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        DPFCCD <> '*ALL  ' AND
     C                             DPFCTP =  '*'
 
      ** If '*All' has been selected for Customer Type, expand entries
     C                   EVAL      WCardF = 'M'
 
      ** Push details
     C                   EVAL      WTFCCD = DPFCCD
     C                   EVAL      WTFCTP = DPFCTP
     C                   EVAL      WTFCD1 = DPFCD1
     C                   EVAL      WTFCD2 = DPFCD2
 
     C                   DELETE    SDFCLSD0
     C                   EXSR      SrDelClass
 
      ** Pop details
     C                   EVAL      DPFCCD = WTFCCD
     C                   EVAL      DPFCTP = WTFCTP
     C                   EVAL      DPFCD1 = WTFCD1
     C                   EVAL      DPFCD2 = WTFCD2
 
     C                   EVAL      WTypeI = 1
 
     C**********         DOU       WTypeI = MaxType                                         MD027682
     C                   DOU       WTypeI > MaxType                                         MD027682
     C                   EVAL      DPFCTP = TypeArr(WTypeI)
     C                   EVAL      WTypeI = WTypeI + 1
     C                   WRITE     SDFCLSD0
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   IF        DPFCCD =  '*ALL  ' AND
     C                             DPFCTP <> '*'
      ** If '*ALL' has been specified for the Classification Code, build selection
     C                   EVAL      WCardF = 'M'
 
     C                   DELETE    SDFCLSD0
 
      ** Push details
     C                   EVAL      WTFCCD = DPFCCD
     C                   EVAL      WTFCTP = DPFCTP
     C                   EVAL      WTFCD1 = DPFCD1
     C                   EVAL      WTFCD2 = DPFCD2
 
     C                   EXSR      SrDelType
 
      ** Pop details
     C                   EVAL      DPFCCD = WTFCCD
     C                   EVAL      DPFCTP = WTFCTP
     C                   EVAL      DPFCD1 = WTFCD1
     C                   EVAL      DPFCD2 = WTFCD2
 
     C                   IF        WClassCnt = 0
     C                   EXSR      SrBldType
     C                   ENDIF
 
     C                   EVAL      WClassI = 1
 
     C                   DOU       WClassI > WClassCnt
 
     C                   IF        ClassArr(WClassI) = *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   EVAL      DPFCCD = ClassArr(WClassI)
     C                   EVAL      WClassI = WClassI + 1
     C                   WRITE     SDFCLSD0
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDelClass - Delete all wildcard classifications from a class *
      *                                                               *
      * Called by: I                                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrDelClass    BEGSR
 
     C     DPFCCD        SETLL     SDFCLSL1
     C     DPFCCD        READE     SDFCLSL1
 
     C                   DOW       NOT %EOF(SDFCLSL1)
 
     C                   DELETE    SDFCLSL1
     C     DPFCCD        READE     SDFCLSL1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDelType - Delete all wildcard classifications from one type *
      *                                                               *
      * Called by: I                                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrDelType     BEGSR
 
     C     DPFCTP        SETLL     SDFCLSL2
     C     DPFCTP        READE     SDFCLSL2
 
     C                   DOW       NOT %EOF(SDFCLSL2)
 
     C                   DELETE    SDFCLSL2
     C     DPFCTP        READE     SDFCLSL2
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBldType - Delete all wildcard classifications from one type *
      *                                                               *
      * Called by: I                                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrBldType     BEGSR
 
     C     *LOVAL        SETLL     SDFATCL0
     C                   READ      SDFATCL0
 
      ** Populate Array with all defined Classification Codes
     C                   DOW       NOT %EOF(SDFATCL0)
     C                   EVAL      WClassCnt = WClassCnt + 1
     C                   EVAL      ClassArr(WClassCnt) = FCCODE
     C                   READ      SDFATCL0
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
 
     C     *ENTRY        PLIST                                                              MD027315
     C                   PARM                    Wupdat                                     MD027315
                                                                                            MD027315
     C     *DTAARA       DEFINE                  LDA
 
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
 
     C     KClassKey     KLIST
     C                   KFLD                    KCode
     C                   KFLD                    KCType
 
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**CTDATA TYPEARR
F(FFI)
N(NFE)
J(Joint Account)
P(Physical Person)
O(Other)
