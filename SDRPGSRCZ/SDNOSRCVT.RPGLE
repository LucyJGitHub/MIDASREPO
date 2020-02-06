     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes Conversion - File to Screen Format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRCVT - Nostro Details Transaction Details Conversion:   *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of the Nostro     *
      *             Code Details from file to screen format           *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 30May14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG12025           Date 19Sep06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Received Settlement Instructions           *
      *  BUG12025 - "Sequence number is not numeric" error message is *
      *              being displayed when trying to maintain Nostro   *
      *              account                                          *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
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
 
     D TranFilFmt    E DS                  EXTNAME(SDNostPD)
      ** Nostro Code Details in File Format
 
     D TrnDets       E DS                  EXTNAME(SDNosrPD)
      ** Nostro Code Details in Screen Format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
     C                   EXSR      INIT
 
      ** Set screen fields
     C                   EXSR      SCREEN
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Nostro Code Details File Format
     C                   PARM                    TranFilFmt
      *
 
      * Output Parameters
 
      * Nostro Details Screen Format
     C                   PARM                    TrnDets
 
      ** Initialise program name
     C                   EVAL      DBPGM = 'SDNosrCVT'
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE =  900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Currency Code
     C                   EVAL      DDCYCD = A7CYCD
      * Nostro Number
     C                   EVAL      DDNONB = A7NONB
      * Account Code
     C                   EVAL      DDACCD = A7ACCD
      * Customer Number
     C                   EVAL      DDCUST = A7CUST
      * Account sequence number
     C     A7ACSN        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDACSN
     C                   ELSE
     C***********        MOVE      *BLANKS       ZFIELD                                     BUG12025
     C***********        MOVE      A7ACSN        ZFIELD                                     BUG12025
     C***********        Z-ADD     0             ZADEC                                      BUG12025
     C***********        EXSR      ZEDIT                                                    BUG12025
     C***********        MOVE      ZFIELD        DDACSN                                     BUG12025
     C                   MOVEL(P)  A7ACSN        DDACSN                                     BUG12025
     C                   ENDIF
      * Nostro short Name
     C                   EVAL      DDNOSN = A7NOSN
      * Our Account No. at Nostro
     C                   EVAL      DDOACN = A7OACN
      * Our receive account
     C                   EVAL      DDORAC = A7ORAC
      * Prime Nostro Indicator
     C                   EVAL      DDPNOI = A7PNOI
      * Branch Code
     C                   EVAL      DDBRCD = A7BRCD
      * CLS Dummy Nostro Indicator
     C                   EVAL      DDCLSD = A7CLSD
      * CLS Pay/Receive Nostro Code
     C                   EVAL      DDLPR =  A7LPR
      * Multiple pay-in generated by time
     C                   EVAL      DDMPGT = A7MPGT
      * Block 3 Number
     C                   EVAL      DDBL3C = A7BL3C
      * Alternative CLS Funding SWIFT ID
     C                   EVAL      DDASID = A7ASID
 
      * Payment Lead time
     C     A7PMLT        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDPMLT
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A7PMLT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDPMLT
     C                   ENDIF
      * CLS settlement Member
     C     A7CLSM        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDCLSM
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A7CLSM        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDCLSM
     C                   ENDIF
      * CLS settlement Member Correspondent
     C     A7CLSC        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDCLSC
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A7CLSC        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDCLSC
     C                   ENDIF
 
      * Receive Settlement Instructions                                                       CDL094
     C                   EVAL      DDRF56 = A7RF56                                            CDL094
     C                   EVAL      DDRA56 = A7RA56                                            CDL094
     C                   EVAL      DDRF57 = A7RF57                                            CDL094
     C                   EVAL      DDRA57 = A7RA57                                            CDL094
     C                   EVAL      DDRF58 = A7RF58                                            CDL094
     C                   EVAL      DDRA58 = A7RA58                                            CDL094
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2006
