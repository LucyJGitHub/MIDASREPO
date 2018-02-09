     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market prices file to screen format')         *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Market Price API                 *
      *                                                               *
      *  FFMPRICVT - Midas FF Market Prices Details Conversion:       *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Market Prices*
      *             Detail from file to screen format                 *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP183  *CREATE    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
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
 
      ** Market Prices Details in File Format
     D TranFilFmt    E DS                  EXTNAME(PRICSD)
 
      ** Market Prices Details in Screen Format
     D TrnDets       E DS                  EXTNAME(FFMPRIPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
 
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D    SARLCD     E                     EXTFLD(LCD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Market Prices Details File Format
 
     C                   PARM                    TranFilFmt
 
      ** Output Parameters
      ** =================
      ** Market Prices Details Screen Format
 
     C                   PARM                    TrnDets
 
      ** Instrument types File format
 
     C                   PARM                    InstTypes
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'FFMPRICVT'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
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
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
     C
      ** Risk Factor
 
     C                   IF        RSKF <> 0
     C                   Z-ADD     7             ZADEC             1 0
     C                   MOVE      *BLANK        ZFIELD           16
     C                   MOVE      RSKF          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        DDRSKF
     C                   ENDIF
 
      ** New Price
 
     C                   EVAL      DDNEWP = *BLANKS
 
     C                   Z-ADD     ITTKDM        FFTKDM            3 0
     C                   Z-ADD     ITMNPF        FFMNPF           15 8
     C                   Z-ADD     NEWP          FFPRIC           15 8
 
      ** Format price
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** -----------------------------------------
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
      ** Screen version of price (16A)
     C                   PARM                    ReturnCode
     C                   PARM                    FFSPRC           16
      ** -------------------------------------
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
      *
      ** Move to screen
      *
     C                   MOVE      FFSPRC        DDNEWP
 
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
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2006
