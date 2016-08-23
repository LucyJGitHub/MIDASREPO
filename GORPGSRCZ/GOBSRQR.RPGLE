     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Retrieve a BSPL Request record')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQR   - Retrieve a BSPL Request record                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS014             Date 10Aug05               *
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
 
     D ScreenFormat  E DS                  EXTNAME(GOBSRQPD)
      * BSPL Request - Screen Format
 
     D FileFormat    E DS                  EXTNAME(GPBSRQPD)
      * BSPL Request - File Format
 
 
      **--------------------------------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      **--------------------------------------------------------------------------------------------
 
 
      * Action, request type and request id
 
     C                   MOVEL     'E'           DDACTN
     C                   MOVEL     I_DDRQTYP     DDRQTYP
     C                   MOVEL     I_DDRQID      DDRQID
 
      * Clear format output from retrieve function
 
     C                   CLEAR                   FileFormat
 
 
      * Retrieve BSPL request details
 
     C                   EXSR      GOBSRQRTV
 
      * Convert to screeen format
 
     C     Idx           IFEQ      0
     C                   EXSR      GOBSRQCVT
     C                   ENDIF
 
 
     C                   EVAL                    Buffer = ScreenFormat
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
 
      * Request Type
      * Request ID
     C                   PARM                    I_DDRQTYP         1
     C                   PARM                    I_DDRQID         15
 
     C                   PARM                    Buffer         6000
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'MIDAS'
 
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      **********************************************************************
     C     GOBSRQRTV     BEGSR
 
     C                   CALLB     'GOBSRQRTV'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * Action
     C                   PARM                    DDACTN            1
      * Request Type
      * Request ID
     C                   PARM                    DDRQTYP           1
     C                   PARM                    DDRQID           15
 
      * OUTPUTS
 
      * BSPL Request - File Format
     C                   PARM                    FileFormat
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIDArr
     C                   PARM      *BLANKS       MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
 
     C                   ENDSR
      **********************************************************************
     C     GOBSRQCVT     BEGSR
 
     C                   CALLB     'GOBSRQCVT'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
 
      * BSPL Request - File Format
     C                   PARM                    FileFormat
 
      * OUTPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    ScreenFormat
 
     C                   ENDSR
      **********************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
