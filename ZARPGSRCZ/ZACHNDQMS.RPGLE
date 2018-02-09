     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA check number of messages on a data queue')
      *****************************************************************
      *                                                               *
      *  Midas - Common functions module                              *
      *                                                               *
      *  ZACHNDQMS - Check number of messages on a data queue         *
      *                                                               *
      *  Function:  This module accepts a data queue name and library *
      *             and returns the number of messages currently      *
      *             on it.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 148855             Date 26Nov98               *
      *                 CAP003  *CREATE    Date 01Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  148855 - Correct handling of the error code parameter by     *
      *           initialising the bytes provided variable.           *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
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
      ** The following /COPY lines include the structures necessary for the
      ** QMHRDQM API.  The first is specific to that API; the second is
      ** the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QMHRDQM
     D/COPY QSYSINC/QRPGLESRC,QUSEC
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
 
     D DtqMsgSel       DS             7
     D  MsgType                1      1    INZ('F')
     D  MsgBytes               4      7B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Number of messages returned from this module
     D NoOfMsgs        S              9P 0
 
 
      ** Length of receiver variable
     D RcvLen          S              9B 0 INZ(54)
 
      ** Format name
     D Format          S              8A   INZ('RDQM0100')
 
      ** Name, library and name-and-library of data queue
     D DtaQName        S             10A
     D DtaQLib         S             10A
     D DtaQNamLib      S             20A
 
      ** Length of message selection information
     D SelInfLen       S              9B 0 INZ(8)
 
      ** Message selection information format name
     D MsgSelFmt       S              8A   INZ('RDQS0100')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Set up the qualified data queue name
     C                   EVAL      DtaQNamLib = DtaQName + DtaQLib
 
      ** Set the type of information to retrieve to indicate first
      ** message
     C                   EVAL      QMHTYPE = 'F'
 
      ** Set the number of message bytes returned to the same as
      ** the data queue length (ideally; use 10 for now)
     C                   EVAL      QMHNTBR = 8
 
     C                   CALL      'QMHRDQM'
      **                            Receiver variable
     C                   PARM                    QMHM010002
      **                            Length of receiver variable
     C                   PARM                    RcvLen
      **                            Format name for returned data
     C                   PARM                    Format
      **                            Qualified data queue name
     C                   PARM                    DtaQNamLib
      **                            Message selection information
     C                   PARM                    QMHS0100
      **                            Length of message selection information
     C                   PARM                    SelInfLen
      **                            Message selection information format
     C                   PARM                    MsgSelFmt
      **                            Error structure
     C                   PARM                    QUSEC
 
 
      ** If an error code was returned by the API, pass it back to
      ** the caller
     C                   IF        QUSEI <> *blanks
     C                   EVAL      ReturnCode = QUSEI
     C                   ELSE
 
      ** Put the retrieved number of messages into the returned field
     C                   EVAL      NoOfMsgs = QMHNBRMA
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs
      ** -------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Number of messages (9,0P)
     C                   PARM                    NoOfMsgs
      ** Inputs
      ** ------
      ** Name of data queue (10A)
     C                   PARM                    DtaQName
      ** Data queue's library (10A)
     C                   PARM                    DtaQLib
 
      ** Set up the 'Bytes provided' field for the API error structure          148855
     C                   EVAL      QUSBPRV = 16                                 148855
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
