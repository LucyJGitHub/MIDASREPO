     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Definition+Menu Items Details Amend Checking')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SFAMUSAMD - SF User Maintenance + Menu Items Details         *
      *                                                               *
      *  Function:  This module compares the fields of an amended     *
      *             User Definition + Menu Items against              *
      *             those currently on file. It checks whether all    *
      *             fields amended are amendable, and if not returns  *
      *             error messages to the calling process.            *
      *             It can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      * (Current) User Definition + Menu Items in Screen Format
     D AMUSScnFm1    E DS                  EXTNAME(SFAMUSPD)
     D                                     PREFIX(U1)
      * (Current) Booking Branches in Screen Format
     D BBRCScnFm1    E DS                  EXTNAME(SFBBRCPD)
     D                                     PREFIX(B1)
      * (Current) Originating Branches in Screen Format
     D OBRCScnFm1    E DS                  EXTNAME(SFOBRCPD)
     D                                     PREFIX(O1)
      * (Current) Companies in Screen Format
     D COMPScnFm1    E DS                  EXTNAME(SFCOMPPD)
     D                                     PREFIX(C1)
 
      * New User Definition + Menu Items in Screen Format
     D NewAmuScn1    E DS                  EXTNAME(SFAMUSPD)
     D                                     PREFIX(U2)
      * New Booking Branches in Screen Format
     D NewBbrScn1    E DS                  EXTNAME(SFBBRCPD)
     D                                     PREFIX(B2)
      * New Originating in Screen Format
     D NewObrScn1    E DS                  EXTNAME(SFOBRCPD)
     D                                     PREFIX(O2)
      * New Companies in Screen Format
     D NewComScn1    E DS                  EXTNAME(SFCOMPPD)
     D                                     PREFIX(C2)
 
      * (Current) User Definition + Menu Items in File Format
     D AMUSFilFmt    E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U1)
      * (Current) Booking Branches in File Format
     D BBRCFilFmt    E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(B1)
      * (Current) Originating Branches in File Format
     D OBRCFilFmt    E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(O1)
      * (Current) Companies in File Format
     D COMPFilFmt    E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(C1)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
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
     D OKAMUS        E DS                  EXTNAME(SFEAMUSPD)
     D                                     PREFIX(U1)
     D OKBBRC        E DS                  EXTNAME(SFEBBRCPD)
     D                                     PREFIX(B1)
     D OKOBRC        E DS                  EXTNAME(SFEOBRCPD)
     D                                     PREFIX(O1)
     D OKCOMP        E DS                  EXTNAME(SFECOMPPD)
     D                                     PREFIX(C1)
 
 
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
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C     U1DDUSRPOK    IFEQ      'N'
     C                   MOVEL     U1DDUSRP      U2DDUSRP
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
      * New User Definition + Menu Items in Screen Format :
     C                   PARM                    NewAmuScn1
      * New Booking Branches in Screen Format :
     C                   PARM                    NewBbrScn1
      * New Originating Branches in Screen Format :
     C                   PARM                    NewObrScn1
      * New Companies in Screen Format :
     C                   PARM                    NewComScn1
      *
      * (Current) User Maintenance + Menu Items in Screen Format :
     C                   PARM                    AMUSScnFm1
      * (Current) Booking Branches in Screen Format :
     C                   PARM                    BBRCScnFm1
      * (Current) Originating Branches in Screen Format :
     C                   PARM                    OBRCScnFm1
      * (Current) Companies in Screen Format :
     C                   PARM                    COMPScnFm1
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAMUS
     C                   PARM                    OKBBRC
     C                   PARM                    OKOBRC
     C                   PARM                    OKCOMP
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
      ** Initialize program name
      *
     C                   MOVEL     'SFAMUSAMD'   DBPGM
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
     C                   MOVEL     900           DBASE                          * DBERR 900 *
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
     C                   MOVEL     901           DBASE                          * DBERR 900 *
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
     C                   MOVEL     902           DBASE                          * DBERR 900 *
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
