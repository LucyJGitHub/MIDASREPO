     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment Log Setup Module')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEMAPYLOG - LE Manual Repayment Log Setup Module             *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Manual Repayment details file into screen      *
      *             format to be used in writing records to the log   *
      *             file                                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 04Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
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
 
     D MaPyFilFmt    E DS                  EXTNAME(LOAMSDK)
     D MR_REC                321    389
     D MR_PAY                390    948
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK) PRefix(PD_)
 
      ** Midas LE API FCIP File Record
 
     D MapyScnfmt    E DS                  EXTNAME(LEMAPYPD)
      ** Midas LE API MAPY First Screen Format Definition File
      *
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive Instructions
      *
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen Payment Instructions
      *
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS Instructions
      *
      **********************************
      ** Settlement instructions part **
      **********************************
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File Receive Instructions
     D  FLREC                  1     69
      *
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ***  File Payment Instructions
     D  FLPAY                  1    559
      *
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS Instructions
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PACTN           S              1A
      *
     D PassDtaDS       DS           512
      ***  Ds to pass details from caller
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE023                  8      8A
     D WrkReactFaCil          16     16A
 
     D TRANSDTL        S           5800A
      ***  Flat structure for 24x7 Interface
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ***  Convert file fields into screen format
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPROC - Convert file fields into screen format              *
      *  Called by: Main                                              *
      *  Calls    : SRSETD, LEMAPYCVT, ZASETINCVT                     *
      *****************************************************************
      *
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      DDACTN = PACTN
 
      ***  Settlement Details
 
     C                   MOVEL     MR_PAY        ##PAYF
     C                   MOVEL     CVMR          FLCVMR
     C                   MOVEL     SCCY          FLPSCY
     C                   MOVEL     ICCY          FLIC72
     C                   MOVE      OSBR          FLPOBR
     C                   MOVEL     MR_REC        ##RECF
     C                   MOVEL     SCCY          FLRSCY
     C                   MOVE      ROBR          FLROBR
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   if        PTYP = 66 or PTYP = 69 and CLE005 = 'Y'
     C                             or PTYP = 72 and CLE005 = 'Y'
     C                   MOVE      *blanks       FLROBR
     C                   else
     C                   MOVE      *blanks       FLPOBR
     C                   endif
 
      ***  Process Conversion of Manual Repayment details
 
     C                   CALLB     'LEMAPYCVT'
 
      ***  INPUTS
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    MaPyFilFmt
     C                   PARM                    PDLoAmFilFmt
     C                   PARM                    CLE005                         Feature
     C                   PARM                    CLE007                         Feature
     C                   PARM                    CLE023                         Feature
     C                   PARM                    WrkReactFacil                  Reactivated facility
 
      ***  OUTPUTS
 
     C                   PARM                    MaPyScnFmt                     MR in screen format
     C                   PARM                    Dummy1            2 0
     C                   PARM                    Dummy2            3 0
     C                   PARM                    Dummy3            3 0
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
 
      ***  do conversion of Settlements details
 
     C                   CALLB     'ZASETINCVT'
      ***  Inputs                                                               File Fmt
     C                   PARM                    ##PAYF                         File paym settl inst
     C                   PARM                    ##RECF                         File Recei Sett Inst
     C                   PARM      *BLANK        ##FRIF                         FRA/IRS Settl. Instr
      ***  Outputs                                                              Screen Fmt
     C                   PARM      *BLANK        ##PAYS                         Paym settl. inst Scr
     C                   PARM      *BLANK        ##RECS                         Recei settl inst Scr
     C                   PARM      *BLANK        ##FRIS                         FRA/IRS Sett inst
     C                   PARM      CCY           #TRCCY                                      CSF011A
     C                   PARM      CCY           #TPCCY                                      CSF011A
 
     C                   EVAL      TRANSDTL = MapyScnFmt + ##RECS + ##PAYS
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *  Called by: Implicitly on program activation                  *
      *  Calls    : None                                              *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ***  INPUT
      ***  =====
     C                   PARM                    RetCodeIn                      Ret Code
     C                   PARM                    PACTN                          Action Code
     C                   PARM                    MapyFilFmt                     Manual Repayment
     C                   PARM                    PdLoAmFilFmt                   PD/RE Details
     C                   PARM                    PassDtaDS                      For CVT
      ***  OUTPUT
      ***  ======
     C                   PARM                    TRANSDTL                       Output
 
      ***  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ***  Database Error
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
