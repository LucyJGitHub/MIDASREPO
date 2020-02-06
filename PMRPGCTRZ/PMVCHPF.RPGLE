     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Charges Profit Centre')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVCHPF    - Validate Portfolio Charges Profit Centre        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033   *CREATE   Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for Profit Centre Details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      ** Externally described DS for Account Officers Details
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** DS for Acess Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Acess Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   MOVE      *BLANK        RETCODEIN
      *
     C                   MOVE      *BLANK        FLDNAMXAR
     C                   MOVE      *BLANK        MSGIDXAR
     C                   MOVE      *BLANK        MSGDTAXAR
     C                   Z-ADD     0             IDX
      *
      ** Validate Portfolio Charges Profit Centre.
      *
     C                   EXSR      SRPrfC
      *
     C     OKPFRC        IFEQ      'N'
     C                   EVAL      RETCODEIN  = 'ERROR'
     C                   ELSE
     C                   EVAL      POPFRC = DDPRFC
     C                   EVAL      DDPRFH = DDPRFC
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrFc - Validate Portfolio Charges Profit Centre            *
      *                                                               *
      *****************************************************************
      *
     C     SRPrfC        BEGSR
      *
     C     DDPRFC        IFNE      *BLANKS
      *
      ** Access Profit Centre details if entered.
      *
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDPRFC        PKEY              4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** Error if entry is not a valid Profit Centre.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKPFRC
     C                   ADD       1             IDX
     C                   MOVEL     'DDPRFC'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM14206'     MSGIDXAR(IDX)
      *
     C                   ELSE
     C                   MOVEL     DSPCCD        DDPRFC
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Charge details have been entered, set Profit Centre
      ** to the default value.
      *
     C     DDCGCO        IFNE      *BLANKS
      *
      ** Retrieve default Profit Centre.
      *
     C     BKPCDU        IFEQ      'Y'
      *
     C                   EXSR      SRPrfCI
      *
     C     WERROR        IFEQ      'Y'
     C                   MOVE      'N'           OKPFRC
     C                   ADD       1             IDX
     C                   MOVEL     'DDPRFC'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM14206'     MSGIDXAR(IDX)
      *
     C                   goto      ESRPRFC
     C                   ENDIF
      *
      ** If no error in the retrieval of default Profit Centre,
      ** use default Profit Centre.
      *
     C                   MOVEL     WPRFC         DDPRFC
      *
     C                   MOVE      'N'           OKPFRC
     C                   ADD       1             IDX
     C                   MOVEL     'DDPRFC'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM14205'     MSGIDXAR(IDX)
      *
     C                   ELSE
      *
      ** Error if entry is blank and Profit Centre Defaults not
      ** being used.
      *
     C                   MOVE      'N'           OKPFRC
     C                   ADD       1             IDX
     C                   MOVEL     'DDPRFC'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM14207'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRPRFC       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrfCI - Retrieve Default Profit Centre                     *
      *                                                               *
      *****************************************************************
      *
     C     SRPrfCI       BEGSR
      *
     C                   MOVEL     *BLANKS       WPRFC             4
     C                   MOVEL     *BLANK        WERROR            1
      *
      ** Retrieve Account Officer details.
      *
     C                   EXSR      SRCusAcc
      *
     C                   MOVE      BBCUST        WCNUM             6
      *
      ** Access Profit Centre Default Matrix file.
      *
     C                   CALLB     'AOPRFMR0'
     C                   PARM                    PRTC1             1
     C                   PARM      '  '          PBOOK             2
     C                   PARM      'PM   '       PTRTP             5
     C                   PARM      'PM'          PSUBT             2
     C                   PARM      BBBRCD        PBRCA             3
     C                   PARM      WDEPT         PDEPT             3
     C                   PARM      PSUSER        PUSER            10
     C                   PARM      WACOF         PACOF             2
     C                   PARM      WCNUM         PCNUM             6
     C                   PARM      '    '        PPRFC             4
      *
     C     PRTC1         IFEQ      '0'
     C                   MOVEL     PPRFC         WPRFC
      *
     C                   ELSE
      *
      ** No default Profit Centre was retrieved.
      *
     C                   MOVEL     'Y'           WERROR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCusAcc - Retrieve Account Officer Details                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCusAcc      BEGSR
      *
     C                   MOVEL     *BLANKS       WACOF             2
     C                   MOVEL     *BLANKS       WDEPT             3
      *
     C     BBACOC        IFNE      *BLANKS
     C                   MOVEL     BBACOC        WACOF
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      '*MSG'        PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      BBACOC        WKEY2             2
     C     SDACOF        PARM      SDACOF        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     BBACOC        DBKEY
     C                   MOVEL     'SDACOFPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     AZDPCD        WDEPT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Charges Profit Centre
      ** - incoming
     C                   PARM                    DDPRFC            4
      *
      ** Portfolio Charges Charge Code
      ** - incoming
     C                   PARM                    DDCGCO            2
      *
      ** SDCUST - Incoming Customer
     C                   PARM                    BBCUST            6
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Profit Centre
      ** - OK indicator
     C                   PARM                    OKPFRC            1
      *
      ** Portfolio Charges Profit Centre
      ** - for file update
     C                   PARM                    POPFRC            4
      *
      ** Portfolio Charges Hidden Profit Centre
     C                   PARM                    DDPRFH            4
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
