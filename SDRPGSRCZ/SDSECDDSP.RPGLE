     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details display')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDDSP - Security Customer Details Display                *
      *                                                               *
      *  Function:  This module displays the Securities Clients       *
      *             Details maintenance screen                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG8799            Date 03Oct05               *
      *                 BUG7945            Date 05Aug05               *
      *                 CSE070             Date 15Feb05               *
      *                 BUG2249            Date 04May04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 29Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8799- CSE070 field is in wrong place (Recompile)          *
      *  BUG7945 - Recompile due to changes in SDSECDDF               *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  BUG2249 - F7/F8 should be disabled during insert operation.  *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDSECDDF  CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       72  Toggle F3 footer text                               *
      *       73  Position cursor on first field if no error          *
      *       77  Display Condition - Autocharge Option, Tax Code fld *
      *       78  Display Condition - Safe Custody fields             *
      *       79  Display Condition - Charges Groups (S01496)         *
      *     80-89 Reference and Part./Non-Part. fields display        *
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @EI             S              1    DIM(60)
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @Z10            S              1    DIM(10) CTDATA PERRCD(10)
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
      ** Security Details in screen format
     D SecDets       E DS                  EXTNAME(SDSECDPD)
 
      ** Security Details OK indicators
     D OKSecDets     E DS                  EXTNAME(SDESECDPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Securities Clients ICD Details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSE022
      ** condition availability of F11 (Depot References)                                     CSE022
     D @EINKK          S              1A                                                      CSE022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKSecDets     @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
 
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      * Protect all fields
     C                   MOVE      *OFF          *IN70
     C***CAP014          SELECT                                                 CAP014
     C***  DDACTN        WHENEQ    'I'                                          CAP014
     C***  DDACTN        WHENEQ    'A'                                          CAP014
     C***                OTHER                                                  CAP014
     C***                MOVE      *ON           *IN70                          CAP014
     C***CAP014          ENDSL                                                  CAP014
 
      *                                                                         CAP014
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBER)      CAP014
      *                                                                         CAP014
     C     @EDTFD        COMP      'Y'                                7070      CAP014
 
      * Enable Function Key - F10 Delete
     C     @EINKJ        COMP      'Y'                                    71
                                                                                              CSE022
      * Enable Function Key - F11 (Other Depot Reference)                                     CSE022
     C     @EINKK        COMP      'Y'                                    67                  CSE022
 
      ** Disable F7/F8 during Insert                                                         BUG2249
     C     DDACTN        COMP      'I'                                    51                 BUG2249
 
      * Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    73
 
 
      * Write message subfile, Securities Clients Details and footer screen
     C                   TIME                    DDTIME
     C                   WRITE     SDSECDS0
     C                   WRITE     SDSECDD1
     C                   WRITE     SDSECDF1
 
 
     C                   READ      SDSECDD1                               99
 
 
      * Set screen error indicators off
     C                   MOVEA     @Z0           *IN(10)
 
      ** Move DDDRF1 and DDDRF2 to DDNDR1 and DDNDR2 respectively                             CSE022
                                                                                              CSE022
     C                   MOVEL     DDDRF1        DDNDR1                                       CSE022
     C                   MOVEL     DDDRF2        DDNDR2                                       CSE022
 
      * Set return keys
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKK         @INKK                                        CSE022
     C                   MOVE      *INKL         @INKL
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
 
      * Return code
     C                   PARM                    RetCodeIn
 
      ** Security Details in screen format
     C                   PARM                    SecDets
 
      ** Security Details OK indicators
     C                   PARM                    OKSecDets
 
      ** Customer Shortname
     C                   PARM                    DDCSSN           10
 
      ** Customer Report Name
     C                   PARM                    DDCRNM           20
 
      ** Customer Report Town
     C                   PARM                    DDCRTN           10
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      ** Called from customer details module or direct from Midas menu
     C                   PARM                    SDCUSDcall        1
 
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      *                                                                         CAP014
      * ENABLED KEY & DETAIL FIELDS                                             CAP014
      *                                                                         CAP014
     C                   PARM                    @EKYFD            1            CAP014
     C                   PARM                    @EDTFD            1            CAP014
      *                                                                         CAP014
      * Enabled Function Keys
      * F10 - Delete
     C                   PARM                    @EINKJ            1
                                                                                              CSE022
      ** F11 - Depot References                                                               CSE022
                                                                                              CSE022
     C                   PARM                    @EINKK                                       CSE022
 
      * OUTPUT PARAMETERS :
 
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKK             1                          CSE022
     C                   PARM                    @INKL             1
 
 
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSECDDSP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
 
      ** Access Securities Clients Details
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
 
 
      ** Check if switchable feature S01496 is switched on.
      ** Private Banking Securities Trading Enhancement
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   END
 
     C                   CALL      'AOSARDR0'                                                 CSE070
     C                   PARM      *BLANKS       @RTCD                                        CSE070
     C                   PARM      '*VERIFY'     @OPTN                                        CSE070
     C                   PARM      'CSE070'      @SARD             6                          CSE070
      *                                                                                       CSE070
     C     @RTCD         IFEQ      *BLANK                                                     CSE070
     C                   MOVE      'Y'           CSE070            1                          CSE070
     C                   ELSE                                                                 CSE070
     C                   MOVE      'N'           CSE070                                       CSE070
     C                   END                                                                  CSE070
 
      * Set function key text toggle - 'F3=Exit' or 'F3=Client Details'
     C                   Eval      *IN72 ='0'
     C                   IF        SDCUSDcall = 'Y'
     C                   Eval      *IN72 ='1'
     C                   ENDIF
 
 
      * Set field display condition - Autocharge Option, tax code field
     C                   Eval      *IN77 = '0'
     C                   IF        BVACOP = 'Y'
     C                   Eval      *IN77 = '1'
     C                   ENDIF
 
 
      * Set field display condition - Safe Custody fields
     C                   Eval      *IN78 = '0'
     C                   IF        BVCUIN = 'Y'
     C                   Eval      *IN78 = '1'
     C                   ENDIF
 
 
      * Set field display condition - Charges Groups
     C                   Eval      *IN79 = '0'
     C                   IF        S01496 = 'Y'
     C                   Eval      *IN79 = '1'
     C                   ENDIF
 
 
      * Condtion depot fields display and shortnames
 
     C                   MOVEA     @Z10          *IN(80)
 
     C                   IF        BVDR1 = *BLANKS
     C                   Eval      *IN81 = '1'
     C                   ELSE
     C                   Eval      DDDSN1 = DepotSn(1)
     C                   ENDIF
 
     C                   IF        BVDR2 = *BLANKS
     C                   Eval      *IN82 = '1'
     C                   ELSE
     C                   Eval      DDDSN2 = DepotSn(2)
     C                   ENDIF
 
     C                   IF        BVDR3 = *BLANKS
     C                   Eval      *IN83 = '1'
     C                   ELSE
     C                   Eval      DDDSN3 = DepotSn(3)
     C                   ENDIF
 
     C                   IF        BVDR4 = *BLANKS
     C                   Eval      *IN84 = '1'
     C                   ELSE
     C                   Eval      DDDSN4 = DepotSn(4)
     C                   ENDIF
 
     C                   IF        BVDR5 = *BLANKS
     C                   Eval      *IN85 = '1'
     C                   ELSE
     C                   Eval      DDDSN5 = DepotSn(5)
     C                   ENDIF
 
     C                   IF        BVDR6 = *BLANKS
     C                   Eval      *IN86 = '1'
     C                   ELSE
     C                   Eval      DDDSN6 = DepotSn(6)
     C                   ENDIF
 
     C                   IF        BVDR7 = *BLANKS
     C                   Eval      *IN87 = '1'
     C                   ELSE
     C                   Eval      DDDSN7 = DepotSn(7)
     C                   ENDIF
 
     C                   IF        BVDR8 = *BLANKS
     C                   Eval      *IN88 = '1'
     C                   ELSE
     C                   Eval      DDDSN8 = DepotSn(8)
     C                   ENDIF
 
     C                   IF        BVDR9 = *BLANKS
     C                   Eval      *IN89 = '1'
     C                   ELSE
     C                   Eval      DDDSN9 = DepotSn(9)
     C                   ENDIF
 
     C                   IF        BVDR10 = *BLANKS
     C                   Eval      *IN80 = '1'
     C                   ELSE
     C                   Eval      DDDSN0 = DepotSn(10)
     C                   ENDIF
 
 
      * Set field display condition - CSE070                                                  CSE070
     C                   Eval      *IN91 = '0'                                                CSE070
     C                   IF        CSE070 = 'Y'                                               CSE070
     C                   Eval      *IN91 = '1'                                                CSE070
     C                   ENDIF                                                                CSE070
                                                                                              CSE070
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDSECDDSP'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
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
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @Z10
0000000000
