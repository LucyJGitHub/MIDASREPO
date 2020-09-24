     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cash Management ICD List')
      *****************************************************************
      *                                                               *
      *  Midas  - Standing Data                                       *
      *                                                               *
      *  SD9452P - Cash Management ICD List                           *
      *                                                               *
      *  Function: This module lists the Cash Management Installation *
      *            Control Data in the system.                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 212319             Date 28May12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  212319 - Refelect SWIFT fromatting when printing ICD text    *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  89 - End of file for SDCMANL0                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit    - Initialisation                                    *
      * SRProcess - Detail processing                                 *
      * SRAudit   - Subroutine to Output Audit Report                 *
      * SRPrint   - Print ICD Details                                 *
      * SRReport  - Write the report                                  *
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

      ** SD Cash Management ICD
     FSDCMANL0  IF   E           K DISK    INFSR(*PSSR)

      ** SD Cash Management ICD List
     FSD9452PAU O    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** SD Cash Management ICD List
     FSD9452PP1 O    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File Information Data Structure for SD9452PP1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** File Information Data Structure for SD9452PAU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7

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

     C                   EXSR      SRInit

     C                   EXSR      SRProcess

     C                   EVAL      *INLR = *On

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR

      ** RCF Processing for Printer File.

     C                   EXSR      SRRCFP1

      ** RCF Processing for Printer File.

     C                   EXSR      SRRCFAU

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPRNT                                                 *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

     C     *LOVAL        SETLL     SDCMANL0
     C                   READ      SDCMANL0                               89

      ** Print the Details

     C                   IF        *IN89 = *Off
     C                   EXSR      SRPrint
     C                   EXSR      SRReport
     C                   ENDIF

      ** If File is empty

     C                   IF        *IN89 = *On
     C                   EXSR      SRAudit
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Setup the Report Fields                             *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

      ** Zero Balancing/Sweeping Hierarchies

     C                   IF        CMZBSH = 'Y'
     C                   EVAL      RZBSH = 'Yes'
     C                   ELSE
     C                   EVAL      RZBSH = 'No '
     C                   ENDIF

      ** Group Account Hierarchies

     C                   IF        CMGACH = 'Y'
     C                   EVAL      RGACH = 'Yes'
     C                   ELSE
     C                   EVAL      RGACH = 'No '
     C                   ENDIF

      ** Top on Balance sheet

     C                   IF        CMTOPB = 'Y'
     C                   EVAL      RTOPB = 'Yes'
     C                   ELSE
     C                   EVAL      RTOPB = 'No '
     C                   ENDIF

      ** Account Code for Shadow Contra entries

     C                   MOVE      CMACSC        RACSC

      ** Level For Shadow Contra Entries

     C                   IF        CMLVSC = 'S'
     C                   EVAL      RLVSC = 'System    '
     C                   ELSE
     C                   IF        CMLVSC = 'H'
     C                   EVAL      RLVSC = 'Hierarchy '
     C                   ELSE
     C                   EVAL      RLVSC = 'No Summary'
     C                   ENDIF
     C                   ENDIF

      ** Account Code for Contra Entries

     C                   MOVE      CMACCE        RACCE

      ** Level For Contra Entries

     C                   IF        CMLVCE = 'S'
     C                   EVAL      RLVCE = 'System    '
     C                   ELSE
     C                   IF        CMLVCE = 'H'
     C                   EVAL      RLVCE = 'Hierarchy '
     C                   ELSE
     C                   EVAL      RLVCE = 'No Summary'
     C                   ENDIF
     C                   ENDIF

      ** Text for Group A/c Hierarchies Off Balance Sheet

     C*****67***         SUBST     CMTXTG:1      RTXTG1                                       212319
     C*****67***         SUBST     CMTXTG:68     RTXTG2                                       212319
     C*****66***         SUBST     CMTXTG:135    RTXTG3                                       212319
     C     65            SUBST     CMTXTG:1      RTXTG1                                       212319
     C     65            SUBST     CMTXTG:66     RTXTG2                                       212319
     C     65            SUBST     CMTXTG:131    RTXTG3                                       212319
     C     5             SUBST     CMTXTG:196    RTXTG4                                       212319

      ** Text for Zero Balance Hierarchies Off Balance Sheet

     C*****67***         SUBST     CMTXTZ:1      RTXTZ1                                       212319
     C*****67***         SUBST     CMTXTZ:68     RTXTZ2                                       212319
     C*****66***         SUBST     CMTXTZ:135    RTXTZ3                                       212319
     C     65            SUBST     CMTXTZ:1      RTXTZ1                                       212319
     C     65            SUBST     CMTXTZ:66     RTXTZ2                                       212319
     C     65            SUBST     CMTXTZ:131    RTXTZ3                                       212319
     C     5             SUBST     CMTXTZ:196    RTXTZ4                                       212319

      ** LOCAL Forward Value Sweeping

     C                   IF        CMLFVS = 'Y'
     C                   EVAL      RLFVS = 'Yes'
     C                   ELSE
     C                   EVAL      RLFVS = 'No '
     C                   ENDIF

      ** LOCAL Forward Value Days

     C                   EVAL      RLFVD = CMLFVD

      ** LOCAL Back Value Days

     C                   EVAL      RLBVD = CMLBVD

      ** EXTERNAL Forward Value Sweeping

     C                   IF        CMEFVS = 'Y'
     C                   EVAL      REFVS = 'Yes'
     C                   ELSE
     C                   EVAL      REFVS = 'No '
     C                   ENDIF

      ** EXTERNAL Forward Value Days

     C                   EVAL      REFVD = CMEFVD

      ** EXTERNAL Back Value Days

     C                   EVAL      REBVD = CMEBVD

      ** External Interface for MT103/MT101

     C                   IF        CMINTF = 'Y'
     C                   EVAL      RINTF = 'Yes'
     C                   ELSE
     C                   EVAL      RINTF = 'No '
     C                   ENDIF

      ** MT103 Default Status

     C                   EVAL      R103S = CM103S

      ** MT101 Default Status

     C                   EVAL      R101S = CM101S

      ** Sweeping in Input Cycle

     C                   IF        CMSWIC = 'Y'
     C                   EVAL      RSWIC = 'Yes'
     C                   ELSE
     C                   EVAL      RSWIC = 'No '
     C                   ENDIF

      ** Input Cycle Sweeping Frequency

     C                   EVAL      RICSF = CMICSF

      ** Group A/c Hierarchy Transaction Type

     C                   EVAL      RGATT = CMGATT

      ** Charge Income Account Code

     C                   MOVE      CMCHAC        RCHAC

      ** Charge Income Profit Centre

     C                   EVAL      RCHPC = CMCHPC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReport - Write the report                                   *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************

     C     SRReport      BEGSR

     C                   WRITE     HEADP1

     C                   WRITE     DETAIL1

     C                   WRITE     TRAILP1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************

     C     SRRCFP1       BEGSR

     C                   EVAL      ZSnum = PSFNum1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr

      ** If Error occurs during ZSFILE processing, then end abnormally

     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFAU - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************

     C     SRRCFAU       BEGSR

     C                   EVAL      ZSnum = PSFNumU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then end abnormally

     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit- Subroutine to Output Audit Report                    *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

      ** Output Report Header and File Controls.

     C                   Write     HEADAU

      ** Output "No Details" message.

     C                   Write     NODTLS

      **  End program

     C                   EVAL      *INLR = *On
     C                   Return

     C                   Endsr
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

     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty

     C/COPY ZACPYSRC,DBFIELDS

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
