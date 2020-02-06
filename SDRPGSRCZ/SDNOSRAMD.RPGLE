     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Code Details Amend Checking')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRAMD - SD Nostro Code Details                           *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended Nostro Codes against those currently on   *
      *             file. It checks whether all fields amended are    *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             It can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 03May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE026 - Consumer Banking                                    *
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
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      * (Current) Customer in Screen Format
      * Nostro Codes in Screen Format
     D NosrScnFm1    E DS                  EXTNAME(SDNOSRPD)
     D                                     PREFIX(@)
 
      * New Nostro Codes in Screen Format
     D NewNosScn1    E DS                  EXTNAME(SDNOSRPD)
 
      * (Current) Nostro Codes in File Format
     D NostFilFmt    E DS                  EXTNAME(SDNOSTPD)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
 
      * Error indicators
     D OKNosr        E DS                  EXTNAME(SDENOSRPD)
 
      ** Data Structure for Event Code Substitution                                         MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C                   MOVEL     *BLANKS       @ERRMSG           7
      *
      **  Compare fields with "amended" values or "changed" values.
      *
     C                   EXSR      COMPFLD
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLD
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLD  - Compare certain fields on the current Customer     *
      *            with those "amended".                              *
      *****************************************************************
     C     COMPFLD       BEGSR
      *
      ** Prime Nostro Indicator
     C     @DDPNOI       IFEQ      'P'
     C     DDPNOI        IFEQ      *Blanks
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPNOI'
     C                   EVAL      MsgIDArr(Idx)   = 'USR1837'
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDPNOI'                               MD000091
     C                   EVAL      BLen = %Len('DPPNOI')                                    MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr + 'DPPNOI'                       MD000091
     C                   EVAL      DDPNOIOK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C     DDPNOIOK      IFEQ      'N'
     C                   MOVEL     @DDPNOI       DDPNOI
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Nostro Codes in Screen Format :
     C                   PARM                    NewNosScn1
      *
      * (Current) Nostro Code in Screen Format :
     C                   PARM                    NosrScnFm1
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKNosr
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDNOSRAMD'   DBPGM
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      **
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
