     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Charges Details Display')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM1DP  - Portfolio Charges Details Display               *
      *                                                               *
      *  Function: This module displays the charges details screen    *
      *            of the Portfolio Definition screen input function. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      ** Charges Details screen
     FPMPFDM1DDFCF   E             WORKSTN
     F                                     SFILE(PMPFDMC1:W_RRN)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     40-55 Field Error - highlight screen fields               *
      *                                                               *
      *       70  Protect detail fields                               *
      *                                                               *
      *       83  Profit Centre used                                  *
      *                                                               *
      *       95  Charges subfile clear                               *
      *                                                               *
      *       96  Message subfile display control                     *
      *       97  Message subfile end                                 *
      *                                                               *
      *       99  End of file indicator                               *
      *                                                               *
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
      **    False      logical = *off (for indcator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,APICTLARR
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
     D MaxChrgArr      C                   CONST(10)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** New Portfolio Charges header details - screen format
     D NwChrgScrnH     DS
     D  DDBCGY                 1      3
     D  DDCSCY                 4      6
     D***DDCUSA                 7     18                                                      CGL029
     D***DDBRCA                19     21                                                      CGL029
     D  DDCUSA                 7     24                                                       CGL029
     D  DDBRCA                25     27                                                       CGL029
      *
      ** DS for Portfolio Charges screen fields - detail
     D ChrgScrnD       DS
     D  DDCGCO                 1      2
     D  DDCGSP                 3     16
     D  DDCGSI                17     17
     D  DDCGEI                18     18
     D  DDCGFQ                19     19
     D  DDCGDY                20     21
     D  DDCGND                22     27
     D  DDCGST                28     28
     D  DDCSFQ                29     29
     D  DDCSDY                30     31
     D  DDCSND                32     37
     D  DDPRFC                38     41
      *
     D  DDVALD                42     42
     D  DDCGCH                43     44
     D  DDCGSH                45     57  0
     D  DDCGEH                58     58
     D  DDCGLH                59     63  0
     D  DDCGDH                64     65
     D  DDCGNH                66     70  0
     D  DDCGFH                71     71
     D  DDCSFH                72     72
     D  DDCSDH                73     74
     D  DDCSNH                75     79  0
     D  DDCGTH                80     80
     D  DDPRFH                81     84
      *
      ** New Portfolio Charges details array - screen format
     D NwChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** Error indicators - charges header
     D PMEPMC          DS
     D  OKBCGY                 1      1
     D  OKCSCY                 2      2
     D  OKCUSA                 3      3
     D  OKBRCA                 4      4
      *
      ** DS for Error indicators - charges details
     D PMEPMCD         DS
     D  OKCGCO                 1      1
     D  OKCGSP                 2      2
     D  OKCGSI                 3      3
     D  OKCGEI                 4      4
     D  OKCGFQ                 5      5
     D  OKCGDY                 6      6
     D  OKCGND                 7      7
     D  OKCGST                 8      8
     D  OKCSFQ                 9      9
     D  OKCSDY                10     10
     D  OKCSND                11     11
     D  OKPRFC                12     12
      *
      ** Error indicators array - charges details
     D PMEPMCArr       S                   DIM(MaxChrgArr)
     D                                     LIKE(PMEPMCD)
      *
     D AZ0             S              1    DIM(20) CTDATA PERRCD(20)
     D WEI             S              1    DIM(4)
     D AEI             S              1    DIM(12)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
      ** Main processing
      *
     C                   EXSR      SRMainP
      *
      ** Return
      *
     C     PINKC         IFEQ      '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAINP - Main processing                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRMainP       BEGSR
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     AZ0           *IN(40)
      *
      ** Move header 'OK' flags into array (for checking).
      *
     C                   MOVEA     PMEPMC        WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx                2 0
     C                   Z-ADD     40            Ex                2 0
      *
     C     Cx            DOUGT     4
      *
     C     WEI(Cx)       IFEQ      'N'
     C     WEI(Cx)       OREQ      'W'
     C                   MOVEL     '1'           *IN(Ex)
     C                   ENDIF
      *
     C                   ADD       1             Cx
     C                   ADD       1             Ex
     C                   ENDDO
      *
      ** Set up the transaction reference to be used by the message handler
      *
     C                   MOVEL     DDCSNM        WTRAN            10
     C                   MOVE      DDPREF        WTRAN
     C                   MOVEL     WTRAN         TranRef
     C                   EVAL      ActionCode = DDACTN
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Enable detail fields (all fields except key fields).
      *
     C     PEDTFD        IFEQ      'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Initialise subfile relative record number and the number
      ** of records written to subfile page.
      *
     C                   Z-ADD     1             WCT               3 0
     C                   Z-ADD     1             W_RRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   MOVE      '1'           *IN95
     C                   WRITE     PMPFDMC0
     C                   MOVE      '0'           *IN95
      *
      ** Write header and screen footer screens.
      *
     C                   WRITE     PMPFDMS0
     C                   WRITE     PMPFDMF1
      *
      ** Read records from the array into the subfile until
      ** a page has been filled (10 elements).
      *
     C     WCT           DOWLE     MaxChrgArr
      *
      ** Read an element in the charges array and set
      ** error indicators for this element.
      *
     C                   EXSR      SRRdChrg
     C                   EXSR      SRSetInd
      *
     C                   Z-ADD     W_RRN         DDSFRN
      *
      ** For each array element read, write it to the subfile.
      *
     C                   WRITE     PMPFDMC1
      *
      ** Set charges subfile error indicators off after write.
      *
     C                   MOVEA     AZ0           *IN(44)
      *
      ** Increment records written and subfile record no.
      ** fields.
      *
     C                   ADD       1             WCT
     C                   ADD       1             W_RRN
      *
     C                   ENDDO
      *
      ** Write the subfile control record to display the
      ** subfile.
      *
     C                   TIME                    DDTIME
     C                   WRITE     PMPFDMC0
      *
      ** If not write only, read charges details screen.
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      PMPFDMC0                               99
     C                   ENDIF
      *
      ** Now, determine which subfile record has been changed
      ** and then, update the charges details array in screen
      ** format.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
     C                   CLEAR                   ChrgScrnD
     C                   READC     PMPFDMC1                               99
      *
     C     *IN99         DOWEQ     '0'
     C                   EVAL      NwChrgScrnArr(W_RRN) = ChrgScrnD
     C                   CLEAR                   ChrgScrnD
     C                   READC     PMPFDMC1                               99
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set return keys.
      *
     C                   MOVE      *INKA         PINKA
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKY         PINKY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdChrg - Read one element from charges details array       *
      *                                                               *
      *****************************************************************
      *
     C     SRRdChrg      BEGSR
      *
      ** Read an entry from the charges details array.
      *
     C                   CLEAR                   ChrgScrnD
     C                   EVAL      ChrgScrnD = NwChrgScrnArr(WCT)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInd - Set error indicators                              *
      *                                                               *
      *****************************************************************
      *
     C     SRSetInd      BEGSR
      *
     C                   MOVEA     PMEPMCArr(WCT)AEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx
     C                   Z-ADD     44            Ex
      *
     C     Cx            DOUGT     12
      *
     C     AEI(Cx)       IFEQ      'N'
     C     AEI(Cx)       OREQ      'W'
     C                   MOVEL     '1'           *IN(Ex)
     C                   ENDIF
      *
     C                   ADD       1             Cx
     C                   ADD       1             Ex
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
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
     C                   PARM                    RetCodeIn
      *
      ** Portfolio Definition key fields
      ** - Action Code
      ** - Customer Number
      ** - Portfolio Reference
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCSNM           10
     C                   PARM                    DDPREF            4
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    DDDELT
      *
      ** New Portfolio Charges header details - screen format
     C                   PARM                    NwChrgScrnH
      *
      ** New Portfolio Charges details array - screen format
     C                   PARM                    NwChrgScrnArr
      *
      ** Enable detail fields
     C                   PARM                    PEDTFD            1
      *
      ** Error indicators - charges header
     C                   PARM                    PMEPMC
      *
      ** Error indicators array - charges details
     C                   PARM                    PMEPMCArr
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU            1
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM                    PINKA             1
     C                   PARM                    PINKC             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKY             1
      *
      ** Allow input of Profit Centre.
      *
     C     BKPRCU        IFEQ      'Y'
     C                   MOVE      '1'           *IN83
     C                   ENDIF
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'PM'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'PMUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Message subfile end indicator and program queue
      ** initialisation
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
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
(c) Misys International Banking Systems Ltd. 2001
** AZ0
00000000000000000000
