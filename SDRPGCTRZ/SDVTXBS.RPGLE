     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Tax Basket')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *          Customer Withholding Tax Details Validation          *
      *                                                               *
      *  SDVTXBS - Validate Tax Basket                                *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Withholding Tax API amendments             *
      *    must not be applied to this source.                        *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Tax Basket Details File
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define key fields,
     D KDDCRTT         S              2A
     D KDDTXBS         S              2A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D Counter         S              3P 0
 
      ** Parameters
     D DDTXBS          S              2A
     D DDDBTT          S              1A
     D DDDCRC          S              1A
     D DDCRTT          S              2A
     D DDTXBSOK        S              1A
 
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
      ** Validate Tax Basket
     C     TxBsKey       KLIST
     C                   KFLD                    KDDCRTT
     C                   KFLD                    KDDTXBS
      ** Populate key fields
     C                   EVAL      KDDCRTT = DDCRTT
     C                   EVAL      KDDTXBS = DDTXBS
 
     C                   IF        DDTXBS <> *BLANK
     C     TxBsKey       CHAIN     SDTXBSL1                           83
     C                   ENDIF
 
     C                   IF        (DDDBTT = 'N' AND DDTXBS = *Blanks)
     C                             OR (DDDCRC = 'E' AND DDTXBS = *Blanks)
     C                             OR (*IN83 = *ON AND DDTXBS <> *Blanks)
     C                   EVAL      DDTXBSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTXBS'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx)  = 'USR7513'
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
     C                   PARM                    DDTXBS
     C                   PARM                    DDDBTT
     C                   PARM                    DDDCRC
     C                   PARM                    DDCRTT
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Tax Basket - OK
     C                   PARM                    DDTXBSOK
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
(c) Finastra International Limited 2006
