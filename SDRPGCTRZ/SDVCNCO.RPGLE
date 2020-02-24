     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Alternative Names & Addr - Country Code Vld')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Alternativee Names & *
      *                                 Addresses Validation          *
      *                                                               *
      *  SDVCNCO - Validate Country Code                              *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Customer Alternative Names & Addresses API          *
      *    amendments must not be applied to this source.             *
      *                                                               *
      *  Last Amend No. MD054781           Date 24Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054781 - Defaulting of Country Location for Wholesale      *
      *              Customers Alternative Name & Address             *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *                                                               *
      *****************************************************************

     FSDCTRYL1  IF   E           K DISK    INFSR(*PSSR)
      * Midas SD Country code file
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)                                     MD054781
      * Midas SD Country code file                                                          MD054781


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

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0

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

      *
      ** VALIDATION
      ** Default Country Code from Customer Details if left blank                           MD054781
     C                   IF        DDCNCD = *BLANKS                                         MD054781
     C     DDCUST        CHAIN     SDCUSTL0                           90                    MD054781
     C                   IF        %FOUND(SDCUSTL0)                                         MD054781
     C                   EVAL      DDCNCD = BBCOLC                                          MD054781
     C                   ENDIF                                                              MD054781
     C                   ENDIF                                                              MD054781

      ** Country Code must be a valid Country Code
     C     DDCNCD        CHAIN     @A4REBR                            90
     C                   IF        *IN90 = *ON
     C                   EVAL      DDCNCDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR0067'
     C                   GOTO      EMAIN
     C                   ENDIF



      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Customer Number                                                                    MD054781
     C                   PARM                    DDCUST            6                        MD054781
      *                                                                                     MD054781
      ** Field(s) requiring validation
     C                   PARM                    DDCNCD            2
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Country Code      - OK
     C                   PARM                    DDCNCDOK          1
      *
      *
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
