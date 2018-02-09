     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade details query module')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETRADQRY - Trade Details Query Module                       *
      *                                                               *
      *  Function:  This module allows Trades to be selected from     *
      *             other programs. It will call the browse module    *
      *             to display a subfile of trades. The trades can    *
      *             then be enquired upon or the trade can be selec-  *
      *             ted with the trade reference returning to the     *
      *             calling program.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202981             Date 28Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186044             Date 08Nov00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010 *CREATE     Date 21Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  202981 - if module is called with action code 'E' only       *
      *           option 'E' should be possible.                      *
      *  186044 - Export variables changed to imports.                *
      *  CSE010 - SE Transactions Enhancements.                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRADHS    IF   E           K DISK
      ** Trade Details
      *
     FMUSER     IF   E           K DISK
      ** Users File
      *
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------------
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Switchable Feature Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long DS for access programs
      *
     D DDOPT           S                   LIKE(@OPSEL) Import
     D*FldNameA********S*************10A***DIM(ArrayMax) Export                               186044
     D*MsgIdA**********S*******************DIM(ArrayMax) Like(#MsgID) Export                  186044
     D FldNameA        S             10A   DIM(ArrayMax) Import                               186044
     D MsgIdA          S                   DIM(ArrayMax) Like(#MsgID) Import                  186044
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*Idx             S              3P 0
      ** Index for arrays of of error message ids etc
      *
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** If screen is Browse, execute subroutine BLDBRW.
      *
     C     @SCRN         DOWEQ     'W'
     C                   EXSR      BLDBRW
     C                   ENDDO
      *
      ** If screen is Read Browse, execute subroutine RDNBRW.
      *
     C     @SCRN         DOWEQ     'R'
     C                   EXSR      RDNBRW
     C                   ENDDO
      *
      ** If screen is Secondary,
      *
     C     @SCRN         IFEQ      'S'
      *
      ** If action is enquiry, execute subroutine ENQ.
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      ENQ
      *
      ** Else, execute subroutine RTV.
      *
     C                   ELSE
     C                   EXSR      RTV
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the screen is Terminate, set on indicator LR.
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *****************************************************************
      *                                                               *
      * BLDBRW - Build Browse Subfile.                                *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     CANC@W                                             *
      *                                                               *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
     C                   MOVE      'N'           @RDNB
      *
     C                   CALLB     'SETRADBRW'
      *
      ** INPUT PARAMETERS :
      ** Return Code
      ** Action Code
      ** Trade Ref. Pointer
      ** Build subfile
      ** Read subfile record
      *
     C                   PARM      *BLANK        RetCodeOut
     C**********         PARM                    DDACTN            1                          202981
     C                   PARM      WACDE         DDACTN            1                          202981
     C                   PARM                    DDTDRF            6
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
      *
      ** OUTPUT PARAMETERS :
      ** Error message
      ** Option Selected
      ** Trade Reference Selected
      ** Command Keys
      *
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @TRSEL            6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** If F3 taken in browse, End Program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      ** If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      ** If F12 not taken in browse, read next browse subfile record.
      *
     C     @INKL         IFNE      *ON
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN             1
      *
      ** Else, exercute subroutine CANC@W.
      *
     C                   ELSE
     C                   EXSR      CANC@W
     C                   ENDIF
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RDNBRW - Read Next Browse Subfile Record.                     *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     RTVTRD - Retrieve Trade                            *
      *                                                               *
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ** Read Next Subfile Record
      *
     C                   CALLB     'SETRADBRW'
      *
      ** INPUT PARAMETERS :
      ** Return code
      ** Action code
      ** Trade Ref. pointer
      ** Build Sub-file
      ** Read Sub-file record
      *
     C                   PARM      *BLANK        RetCodeOut
     C**********         PARM                    DDACTN            1                          202981
     C                   PARM      WACDE         DDACTN            1                          202981
     C                   PARM                    DDTDRF            6
     C                   PARM      *BLANK        @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
      *
      ** OUTPUT PARAMETERS :
      ** Error Message
      ** Option Selected
      ** Trade Ref. selected
      *
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @TRSEL            6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** If Trade read from subfile
      *
     C     @TRSEL        IFNE      *BLANKS
      *
      ** Retrieve Trade details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     DDOPT         DDACTN
     C                   MOVEL     @TRSEL        DDTDRF
     C                   EXSR      RTVTRD
      *
      ** Put the trade on the SECONDARY screen if valid
      ** else put it on the PRIMARY screen
      *
     C     Ix            IFEQ      *ZERO
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'W'           @SCRN
     C                   END
     C                   Z-ADD     *Zeros        Ix
      *
      * Else, go to initial screen
      *
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENQ -                                                         *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     ENQ           BEGSR
      *
     C                   CALLB     'SETRADENQ'
      *
      ** INPUT PARAMETERS:
      ** Action Code
      ** Trade Reference
      *
     C                   PARM                    DDACTN
     C                   PARM                    DDTDRF
      *
      ** OUTPUT PARAMETERS:
      ** Return Code
      *
     C                   PARM      *BLANKS       RetCode
      *
      ** If F3 OR F12 taken, End Program
      *
     C     RetCode       IFEQ      'Q'
     C     RetCode       OREQ      'P'
     C                   EXSR      ENDP
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTV -                                                         *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     RTV           BEGSR
      *
     C                   MOVEL     DDTDRF        TradRef
     C                   EXSR      ENDP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVTRD - Retrieve Trade                                       *
      *                                                               *
      * Called By: RDNBRW                                             *
      *                                                               *
      * Calls:     ACSSES -                                           *
      *            ACSSEM -                                           *
      *                                                               *
      *****************************************************************
     C     RTVTRD        BEGSR
      *
      ** Initialize validation flags to valid.
      *
     C                   MOVEL     'Y'           OKACTN            1
     C                   MOVEL     'Y'           OKTDRF            1
      *
      ** Valid action codes are "E" for Enquire and "1" for Retrieve.
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     '1'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameA(Ix)
     C                   MOVEL     'SEM1057'     MsgIdA(Ix)
     C                   MOVEL     'SEM1057'     @ERRMS
     C                   ENDIF
      *
     C     DDTDRF        IFNE      *BLANKS
      *
      **  Test if Trade Reference is numeric.
      *
     C                   TESTN                   DDTDRF               98
      *
      ** If not numeric, send error message.
      *
     C     *IN98         IFNE      *ON
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDTDRF'      FldNameA(Ix)
     C                   MOVEL     'SEW1018'     MsgIdA(Ix)
     C                   GOTO      EndRTVTRD
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Continue validation if both action code and trade reference are valid.
      *
     C     DDTDRF        CHAIN     TRADHS                             70
      *
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'N'           OKTDRF
     C                   ADD       1             Ix                3 0
     C                   MOVEL     'DDTDRF'      FldNameA(Ix)
     C                   MOVEL     'SEW1019'     MsgIdA(Ix)
     C                   GOTO      EndRTVTRD
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
      *
      ** If single branch environment
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      ACSSES
     C                   ELSE
     C                   EXSR      ACSSEM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EndRTVTRD     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ACSSES -                                                      *
      *                                                               *
      * Called By: RTVTRD                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
      *
      ** If there's an error,
      *
     C     @ERR          IFNE      *ZERO
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameA(Ix)
     C                   MOVEL     'SEM1021'     MsgIdA(Ix)
     C                   MOVEL     'SEM1021'     @ERRMS
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ACSSEM -                                                      *
      *                                                               *
      * Called By: RTVTRD                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      ** Check user's authority for the action and branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    TDBA              3
     C                   PARM      0             @@ERR             1 0
      *
      ** If there's an error,
      *
     C     @@ERR         IFNE      0
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameA(Ix)
     C                   MOVEL     'SEM1021'     MsgIdA(Ix)
     C                   MOVEL     'SEM1021'     @ERRMS
     C                   ENDIF
      *
      ** If Originating Branches are used and Originating Branch/User Validation
      ** is yes, check user's authority for the Originating Branch.
      *
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM                    ORBR
     C                   PARM                    @@ERR
      *
      ** If there's an error,
      *
     C     @@ERR         IFNE      0
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameA(Ix)
     C                   MOVEL     'SEM1021'     MsgIdA(Ix)
     C                   MOVEL     'SEM1021'     @ERRMS
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDM@P - Send a Message to Primary Details Screen             *
      *                                                               *
      * Called By: BLDBRW                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'SEM1021'
     C                   MOVE      'N'           OKACTN
     C                   END
      *
      ** Trade reference on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'SEW1018'
     C                   MOVE      'N'           OKTDRF
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CANC@W -                                                      *
      *                                                               *
      * Called By: BLDBRW                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     CANC@W        BEGSR
      *
     C                   MOVEL     'N'           @RDNB
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENDP - Terminate the Program                                  *
      *                                                               *
      * Called By: BLDBRW                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INITIAL - Initial Subroutine                                  *
      *                                                               *
      * Called By: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     INITIAL       BEGSR
      *
     C                   MOVEL     'N'           @RDNB             1
     C                   MOVEL     'W'           @SCRN
     C                   MOVEL     *BLANKS       @ERRMS
     C                   MOVEL     *BLANKS       @OPSEL
     C                   MOVEL     *BLANKS       @TRSEL
      *
      ** Access MIDAS User Details
      *
     C     PSUser        CHAIN     MUSER                              70
      *
      ** If the user is not found in the user file, Database error.
      *
     C     *IN70         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVEL     'MUSERDD '    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     PSUser        DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
     C
     C     *Entry        PLIST
      *
      ** INPUTS PARAMETERS:
      ** Trade Reference
      ** Return Code
      *
     C                   PARM                    RetCode           1
     C                   PARM                    TradRef           6
      *                                                                                       202981
     C                   MOVE      RetCode       WACDE             1                          202981
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SETRADQRY'   DBPGM
     C                   OUT       LDA
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if MT5XX Message Generation switchable feature is ON.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'S01401'      PSARD             6
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01401'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01401            1
     C                   ELSE
     C                   MOVE      'N'           S01401
     C                   END
      *
      ** Check if MT5XX Phase 2 Message Generation switchable feature in ON.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW003'      PSARD
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSW003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW003
     C                   ELSE
     C                   MOVE      'N'           CSW003            1
     C                   END
      *
      ** Execute the Initial Subroutine
      *
     C                   Z-ADD     0             Ix
     C                   EXSR      INITIAL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
