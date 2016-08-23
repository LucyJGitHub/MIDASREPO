     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Country of Tax Treaty')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *          Customer Withholding Tax Details Validation          *
      *                                                               *
      *  SDVCRTT - Validate Country of Tax Treaty                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Customer Withholding Tax API amendments             *
      *    must not be applied to this source.                        *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      * DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * External DS for Country codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      * Current Country of tax treaty set array
     D VCRTTSET        S              2A   DIM(30)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
      * Next available position for writing CRTT set array
     D Index           S              3P 0
     D Counter         S              3P 0
 
      ** Work Variables
     D Rtcd            S              7A
     D Optn            S              7A
     D DDCRTT          S              2A
     D DDCRTTOK        S              1A
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      ** Validation
      ** Validate Country of tax treaty
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       Rtcd
     C                   PARM      '*KEY   '     Optn
     C                   PARM                    DDCRTT
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        Rtcd <> *Blanks
      ** Error - Wrong Country of tax treaty
     C                   EVAL      DDCRTTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRTT'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx) = 'USR7504'
     C                   RETURN
     C                   ENDIF
     C                   EVAL      DDCRTT = A4CNCD
 
      ** Check for duplicate Country of Tax Treaty combination
 
     C     DDCRTT        LOOKUP    VCRTTSET                               99
      ** Not found
     C                   IF        *IN99 = *OFF
 
      ** Only one Country of Tax Treaty allowed for customer
 
      ** Write in Country of Tax Treaty array at next available
      ** position
     C                   EVAL      Index = Index + 1
     C                   EVAL      VCRTTSET(Index) = DDCRTT
     C                   ELSE
      ** Error - duplicate Code/Set combination
     C                   EVAL      DDCRTTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRTT'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx) = 'USR7505'
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
     C                   PARM                    DDCRTT
     C                   PARM                    VCRTTSET
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Country of Tax Treaty - OK
     C                   PARM                    DDCRTTOK
      ** Next available position
     C                   PARM                    Index
      ** Counter
     C                   PARM                    Counter
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
