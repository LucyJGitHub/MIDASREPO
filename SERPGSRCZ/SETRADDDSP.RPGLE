     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade order details screen display')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SETRADDDSP - SE Trade Order Details Screen Display           *
      *                                                               *
      *  Function:  This module allows entry of a SE Touch of Finance *
      *             Order number which is to be enquired, deleted,    *
      *             authorised or approved.  The user can also request*
      *             to review the trades or not.  If trades are not   *
      *             reviewed, they will get deleted, authorised or    *
      *             approved without displaying any details           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189751             Date 27Feb01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE019             Date 05Apr00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010  *CREATE    Date 21Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  189751 - MUI Trade Order details maintenance should display  *
      *           allowable action codes.                             *
      *  CSE019 - SE Trades Selections Enhancements                   *
      *  CSE010 - SE Transactions Enhancements                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSETRADDDF CF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *  01 - Allowable action codes are E, D, Y and P.               *                       189751
      *  02 - Allowable action codes are E, D, and Y.                 *                       189751
      *  03 - Allowable action codes are E and D.                     *                       189751
      *  20 - Error in Action Code                                    *
      *  21 - Error in Order Number                                   *
      *  22 - Error in Review Trades                                  *
      *  24 - Error in System Id                                      *         CSE019
      *  25 - Error in Date                                           *         CSE019
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
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
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------

      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------

      **------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **------------------------------------------------------------------------

      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **------------------------------------------------------------------------

     D FldNoArray      S              5P 0 DIM(ArrayMax)

      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       189751
      ** SE Trade Authorisation (SDSTRDPD)                                                    189751
     D BVAUTH          S              2A                                                      189751
      *                                                                                       189751
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ** Main processing
      *
      ** Setup Action Code to be used by the message handler
      *
     C                   Eval      ActionCode = DDACTN
      *
      ** If Action Code is in error
      *
     C                   If        OKACTN='N'
     C                   Move      *ON           *IN20
     C                   Endif
      *
      ** If Order number is in error
      *
     C                   If        OKORDE='N'
     C                   Move      *ON           *IN21
     C                   Endif
      *
      ** If Review Trades is in error
      *
     C                   If        OKREVW='N'
     C                   Move      *ON           *IN22
     C                   Endif
      *                                                                         CSE019
      ** If System Id is in error                                               CSE019
      *                                                                         CSE019
     C                   If        OKSTID ='N'                                  CSE019
     C                   Move      *ON           *IN24                          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** If Date is in error                                                    CSE019
      *                                                                         CSE019
     C                   If        OKDATE ='N'                                  CSE019
     C                   Move      *ON           *IN25                          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
     C                   Movel     DDACTN        SACTN                          CSE019
     C                   Movel     DDSTID        SSTID                          CSE019
     C                   Movel     DDDATE        SDATE                          CSE019
     C                   Movel     DDORDE        SORDE                          CSE019
     C                   Movel     DDREVW        SREVW                          CSE019
     C                   Endif                                                  CSE019
      *
      ** Blank out input fields if no error
      *
     C                   If        *IN20 = *off and *in21 = *off
     C                             and *in22 = *off
     C                             and *in24 = *off and *in25 = *off            CSE019
     C                   MOVE      *Blanks       SACTN
     C                   MOVE      *Blanks       SSTID                          CSE019
     C                   MOVE      *Blanks       SDATE                          CSE019
     C                   MOVE      *Blanks       SORDE
     C                   MOVE      *Blanks       SREVW
     C
     C                   ENDIF
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Write message subfile, details and footer screen
      *
     C                   WRITE     SETRADDC0
      *                                                                         CSE019
     C     CSE019        Ifne      'Y'                                          CSE019
     C                   WRITE     SETRADDD1
      *
      ** Read Details Screen
      *
     C                   READ      SETRADDD1                              23
     C                   ELse                                                   CSE019
     C                   WRITE     SETRADDD2                                    CSE019
      *                                                                         CSE019
      ** Read Details Screen                                                    CSE019
      *                                                                         CSE019
     C                   READ      SETRADDD2                              23    CSE019
     C                   Endif                                                  CSE019
     C                   CALL      'ZA0250'
      *
      ** Move Screen fields to parameter
      *
     C                   MOVE      SACTN         DDACTN
     C                   MOVE      SSTID         DDSTID                         CSE019
     C                   MOVE      SDATE         DDDATE                         CSE019
     C                   MOVE      SORDE         DDORDE
     C                   MOVE      SREVW         DDREVW
      *
      ** Set error indicators off
      *
     C                   MOVE      *OFF          *IN20
     C                   MOVE      *OFF          *IN21
     C                   MOVE      *OFF          *IN22
     C                   MOVE      *OFF          *IN24                          CSE019
     C                   MOVE      *OFF          *IN25                          CSE019
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKL         @INKL
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
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
      ** Input Parameters
      ** Return Code
      ** Action Code
      ** Order Number
      ** Review Trade
      ** Action Code OK
      ** System Id                                                              CSE019
      ** Date                                                                   CSE019
      ** Order Number OK
      ** Review Trade OK
      ** Error fields array
      ** Message Ids Array
      ** Message data array
      *
     C                   PARM                    RetrnCod          6
     C                   PARM                    DDACTN            1
     C                   PARM                    DDSTID            2            CSE019
     C                   PARM                    DDDATE            6            CSE019
     C                   PARM                    DDORDE            6
     C                   PARM                    DDREVW            1
     C                   PARM                    OKACTN            1
     C                   PARM                    OKSTID            1            CSE019
     C                   PARM                    OKDATE            1            CSE019
     C                   PARM                    OKORDE            1
     C                   PARM                    OKREVW            1
     C                   PARM                    CSE019            1            CSE019
     C                   PARM                    BVAUTH                                       189751
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Output Parameters
      ** Function Keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKE             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADDDSP'  DBPGM
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        SUser
     C                   MOVEL     PsJobName     SWSID
     C                   MOVEL     BJMRDT        SRuna
      *                                                                                       189751
      ** Display allowable action codes depending on Trade Authorisation                      189751
      ** indicator found in SDSTRDPD file.                                                    189751
      *                                                                                       189751
     C                   SELECT                                                               189751
      *                                                                                       189751
      ** Valid action codes are E, D, Y and P.                                                189751
      *                                                                                       189751
     C                   WHEN      BVAUTH = '20'                                              189751
     C                   EVAL      *IN01 = *ON                                                189751
      *                                                                                       189751
      ** Valid action codes are E, D and Y.                                                   189751
      *                                                                                       189751
     C                   WHEN      BVAUTH <> '00' AND                                         189751
     C                             BVAUTH <> '15'                                             189751
     C                   EVAL      *IN02 = *ON                                                189751
      *                                                                                       189751
      ** Valid action codes are E and D.                                                      189751
      *                                                                                       189751
     C                   OTHER                                                                189751
     C                   EVAL      *IN03 = *ON                                                189751
     C                   ENDSL                                                                189751
      *
      ** Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ

      **------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
