     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Validate Batch Number')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCVBATN - Validate Batch Number                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
 
      ** Replication file - keyed on Batch Number and Physical File
     FSCFDTLL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data Replication Error Indicator File
     D OKFlags       E DS                  EXTNAME(SCERPCNPD)
 
      ** Data Replication File Definition Detail
     D NwRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
     D                                     PREFIX(NW:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indexes for Error and Warning arrays
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters for ZALIGN
     D PRetCode        S              7A
     D ZField          S             16A
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAField         S             16A
 
     D P_BatNum        S              1A
     D KBatNum         S              1A
 
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
 
      ** Initialisation
 
     C                   MOVE      *BLANKS       RetCodeIn
     C                   MOVE      *BLANKS       FldNamXAr
     C                   MOVE      *BLANKS       MsgIDXAr
     C                   MOVE      *BLANKS       MsgDtaXAr
     C                   MOVE      *BLANKS       WFldNmXAr
     C                   MOVE      *BLANKS       WMsgIDXAr
     C                   MOVE      *BLANKS       WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   EVAL      NWBATN = *Blanks
 
      ** Validate Batch Number field
 
     C                   EXSR      SR_BatchNum
 
      ** If an error has occurred, set return code
 
     C                   IF        OKBATN = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   EVAL      NWBATN = P_BatNum
 
      ** Return to calling program
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SR_BatchNum - Validate Batch Number                           *
      *                                                               *
      *****************************************************************
     C     SR_BatchNum   BEGSR
 
      ** Default to '0' if not entered
 
     C                   IF        P_BatNum = *Blanks
     C                   EVAL      P_BatNum = '0'
     C                   ENDIF
 
      ** Validate if Batch number entered is numeric
 
     C                   IF        P_BatNum <> *Blanks
 
     C                   EVAL      ZField = P_BatNum
     C                   EVAL      ZADEC = 0
     C                   EVAL      ZADIG = 1
     C                   EVAL      ZAField = *Blanks
 
     C                   CALL      'ZALIGN'
     C                   PARM      *Blanks       PRetCode
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAField
 
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      OKBATN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1BATN'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0013'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check that Batch 0 must exist before any other batch can be
      ** used
 
     C                   OPEN      SCFDTLL4
     C                   IF        P_BatNum <> '0'
     C                   EVAL      KBatNum = '0'
     C     KBatNum       CHAIN     SCFDTLL4                           89
 
     C                   IF        *IN89 = *On
     C                   EVAL      OKBATN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1BATN'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0019'
     C                   ELSE
 
      ** If Batch number is found, make sure that the replication file is not
      ** the same
 
     C                   IF        FDPHYF = NWPHYF
     C     KBatNum       READE     SCFDTLL4                               89
     C                   IF        *IN89 = *On
     C                   EVAL      OKBATN = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = '#1BATN'
     C                   EVAL      MsgIdXAr(Idx) = 'DRC0019'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   CLOSE     SCFDTLL4
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** ------
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Field requiring validation: Replication Select
 
     C                   PARM                    P_BatNum
 
      ** OUTPUTS
      ** -------
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** OK Flag: Replication Select
 
     C                   PARM                    OKFlags
 
      ** File Format
 
     C                   PARM                    NwRepFilFmt
 
      ** Program, module and procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
