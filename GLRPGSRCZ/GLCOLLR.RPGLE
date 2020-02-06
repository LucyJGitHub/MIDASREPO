     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details retrieve a record')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GLCOLLR   - GL Collateral details retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP084  *CREATE    Date 20Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP084 - API wrapper project.                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** SCREEN FORMATS
      **-----------------------------------------------------------------------
 
     D DealScnFmt    E DS                  EXTNAME(GLCOLDPD)
      * Deal in Screen Format
 
 
      **-----------------------------------------------------------------------
      ** FILE FORMATS
      **-----------------------------------------------------------------------
 
     D DealFilFmt    E DS                  EXTNAME(GLCOLLPD)
      ** Deal in File Format from the file where original transactions are written to
 
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **-----------------------------------------------------------------------
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   DealFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      GLCOLLRED
     C                   ELSE
     C                   MOVEL     DDCREF_In     @TRRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read
      * and no error message returned
      *
     C     @TRRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @TRRED        DDCREF
     C                   EXSR      GLCOLLRTV
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      GLCOLLCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCREF'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
     C                   EVAL                    Buffer = DealScnfmt
     C                                           +CDCOPT
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCREF_In        10
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLCOLA02
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLCOLLRED     BEGSR
      *
     C                   CALLB     'GLCOLLRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM      DDCREF_In     DDCREF           10
      *
      * Front Office ID
     C                   PARM                    DDFRTN           20
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @TRRED           10
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C     GLCOLLRTV     BEGSR
 
      *
     C                   CALLB     'GLCOLLRTV'
      ** INPUT PARAMETERS:
      ** Initial screen fields
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCREF           10
     C                   PARM                    DDREVF           10
     C                   PARM                    DDREQR            1
     C                   PARM                    DDSENT            1
     C                   PARM                    DDSCMP            3
     C                   PARM                    DDSBRC            3
     C                   PARM                    DDSCOL            5
     C                   PARM                    DDSCNU           10
     C                   PARM                    DDSCCY            3
     C                   PARM                    DDSVAL           16
     C                   PARM                    DDSGNS            1
      *
     C                   PARM                    CGL012
      *
      ** Mode of operation
     C                   PARM      *BLANK        ModeOp            6
      *
      ** Response Mode
     C                   PARM      'S'           RespMode          1
      *
      ** Front Office Id
     C                   PARM                    DDFRTN           20
      *
      ** OUTPUT PARAMETERS:
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *
      ** Collateral details (file format)
     C                   PARM      *BLANKS       DealFilFmt
      *
      ** OK Flags
     C                   PARM      *BLANK        DDACTNOK          1
     C                   PARM      *BLANK        DDCREFOK          1
     C                   PARM      *BLANK        DDREVFOK          1
     C                   PARM      *BLANK        DDREQROK          1
     C                   PARM      *BLANK        DDSENTOK          1
     C                   PARM      *BLANK        DDSCMPOK          1
     C                   PARM      *BLANK        DDSBRCOK          1
     C                   PARM      *BLANK        DDSCOLOK          1
     C                   PARM      *BLANK        DDSCNUOK          1
     C                   PARM      *BLANK        DDSCCYOK          1
     C                   PARM      *BLANK        DDSVALOK          1
     C                   PARM      *BLANK        DDSGNSOK          1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C     GLCOLLCVT     BEGSR
 
     C                   CALLB     'GLCOLLCVT'
 
 
      * INPUTS
      * Return Code
     C                   PARM      *BLANKS       ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      *
     C                   PARM                    CGL012            1
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
 
      ** Transaction Status
     C                   PARM      *BLANKS       TransStat         7
      *
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2003
