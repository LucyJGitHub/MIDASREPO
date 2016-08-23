     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details display 2')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECD2DP - Security Customer Details Display 2              *
      *                                                               *
      *  Function:  This module displays the Securities Clients       *
      *             Details maintenance screen 2                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE042             Date 05Feb03               *
      *  Prev Amend No. CSE041             Date 05Feb03               *
      *                 CSE039 *CREATE     Date 05Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDSECD2DF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-69 Field Error - highlight screen fields               *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       73  Position cursor on first field if no error          *
      *       77  Display Condition - CSE039                          *
      *       78  Display Condition - CSE041                          *                       CSE041
      *       79  Display Condition - CSE042                          *                       CSE042
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
 
      ** Security Details in screen format
     D SecDets       E DS                  EXTNAME(SDSECDPD)
 
      ** Security Details Screen 2 OK indicators
     D OKSecDets2    E DS                  EXTNAME(SDESECD2PD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKSecDets2    @EI
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
 
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBER)
      *
     C     @EDTFD        COMP      'Y'                                7070
 
      * Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    73
 
 
      * Write message subfile, Securities Clients Details and footer screen
     C                   TIME                    DDTIME
     C                   WRITE     SDSECD2S0
     C                   WRITE     SDSECD2D1
     C                   WRITE     SDSECD2F1
 
 
     C                   READ      SDSECD2D1                              99
 
 
      * Set screen error indicators off
     C                   MOVEA     @Z0           *IN(10)
 
      * Set return keys
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Security Details screen 2 OK indicators
     C                   PARM                    OKSecDets2
 
      ** Customer Shortname
     C                   PARM                    DDCSSN           10
 
      ** Customer Report Name
     C                   PARM                    DDCRNM           20
 
      ** Customer Report Town
     C                   PARM                    DDCRTN           10
 
      ** Called from Customer Details Module
     C                   PARM                    SDCUSDcall        1
 
      ** Automatic Settlement of Trades
     C                   PARM                    CSE039            1
 
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041            1                          CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042            1                          CSE042
 
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
 
      * OUTPUT PARAMETERS :
 
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSECD2DP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Set field display condition - Automatic Settlement of Trades (CSE039)
      **                               and Classification = 'S' or 'D'.
     C                   Eval      *IN77 = '0'
     C                   IF        CSE039 = 'Y'
     C                   IF        DDCLAS = 'S' OR DDCLAS = 'D'
     C                   Eval      *IN77 = '1'
     C                   ENDIF
     C                   ENDIF
 
      ** Set field display condition - DVP/RVP Processing (CSE041)                            CSE041
      **                               and Classification = 'S' or 'D'.                       CSE041
     C                   Eval      *IN78 = '0'                                                CSE041
     C                   IF        CSE041 = 'Y'                                               CSE041
     C                   IF        DDCLAS = 'S' OR DDCLAS = 'D'                               CSE041
     C                   Eval      *IN78 = '1'                                                CSE041
     C                   ENDIF                                                                CSE041
     C                   ENDIF                                                                CSE041
                                                                                              CSE041
      ** Set field display condition - Auto Feed of Trades and Movements (CSE042)             CSE042
      **                               and Classification = 'S' or 'D'.                       CSE042
     C                   Eval      *IN79 = '0'                                                CSE042
     C                   IF        CSE042 = 'Y'                                               CSE042
     C                   IF        DDCLAS = 'S' OR DDCLAS = 'D'                               CSE042
     C                   Eval      *IN79 = '1'                                                CSE042
     C                   ENDIF                                                                CSE042
     C                   ENDIF                                                                CSE042
 
 
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
     C                   MOVEL     'SDSECD2DP'   DBPGM
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
(c) Misys International Banking Systems Ltd. 2003
** @Z0
000000000000000000000000000000000000000000000000000000000000
