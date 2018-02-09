     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Documentation Received')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Withholding Tax      *
      *                                     Details Validation        *
      *                                                               *
      *  SDVDCRC - Validate Documentation Received                    *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Withholding Tax API amendments             *
      *    must not be applied to this source.                        *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13608           Date 21Mar07               *
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13608 - MidasPlus error occurred when validating Customer *
      *             Withholding tax details                           *
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
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Externally described DS for Securities client Detail file
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @KeyC           S             10A
     D @KySt           S              7A
      ** Work variable for Country of Location(BBCOLC)
     D WBBCOLC         S              2A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D Counter         S              3P 0
 
      ** Index for arrays of error message ids etc
     D DDDCRC          S              1A
     D DDCRTT          S              2A
     D DDINTS          S              3A
     D DDCSNO          S              6A
     D DDDCRCOK        S              1A
 
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
 
      ** If the Country of Tax is the same as residence and the
      ** Classification of the customer is not 'I', then the
      ** Documentation status can only have the following value,
      ** 'U', 'D', 'E', 'C' or 'L'.
     C                   IF        DDCRTT = WBBCOLC AND BFCLAS <> 'I'
     C                   IF        DDDCRC = *BLANK OR
     C                             DDDCRC <> 'U' AND
     C                             DDDCRC <> 'D' AND
     C                             DDDCRC <> 'E' AND
     C                             DDDCRC <> 'C' AND
     C                             DDDCRC <> 'L'
 
     C                   EVAL      *IN23 = *On
     C                   EVAL      DDDCRCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDCRC'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx)  = 'USR7522'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDDCRC = *BLANK OR
     C                             DDDCRC <> 'Y' AND
     C                             DDDCRC <> 'N' AND
     C                             DDDCRC <> 'D' AND
     C                             DDDCRC <> 'U' AND
     C                             DDDCRC <> 'C' AND
     C                             DDDCRC <> 'L' AND
     C                             DDDCRC <> 'I' AND
     C                             DDDCRC <> 'E'
 
     C                   EVAL      *IN23 = *On
     C                   EVAL      DDDCRCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDCRC'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx)  = 'USR7507'
     C                   ENDIF
     C                   ENDIF
 
      ** If Customer is an internal customer, then documentation
      ** Received status can only be 'Y'.
 
     C                   IF        BFCLAS = 'I' and DDDCRC = *BLANK
     C                   EVAL      DDDCRC = 'Y'
     C                   ENDIF
      ** *IN23, is field error indicator
     C                   IF        BFCLAS = 'I' AND DDDCRC <> 'Y'
     C                   EVAL      *IN23 = *On
 
     C                   EVAL      DDDCRCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDCRC'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx)  = 'USR7523'
     C                   ENDIF
 
     C                   IF        *IN23 = *OFF
     C                   IF        (DDINTS = 'WA' OR DDINTS = 'QI' OR
     C                              DDINTS = 'NQI' OR DDINTS = 'FTE') AND
     C                              (DDDCRC <> 'I')
     C                   EVAL      *IN23 = *On
 
     C                   EVAL      DDDCRCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDCRC'
     C                                        + %Trim (%Char(Counter))
     C                   EVAL      MsgIdXAr(Idx)  = 'USR7508'
 
     C                   ELSE
     C                   EVAL      *IN23 = *Off
     C                   ENDIF
 
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
     C                   PARM                    DDDCRC
     C                   PARM                    DDCRTT
     C                   PARM                    DDINTS
     C                   PARM                    DDCSNO
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Documentation Received - OK
     C                   PARM                    DDDCRCOK
      ** Counter
     C                   PARM                    Counter
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access customer file for Country of Location field(BBCOLC)
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCSNO        @KeyC
     C                   PARM      *Blanks       @KySt
     C     SDCUST        PARM      SDCUST        DSSDY
      ** Work variable for Country of Location(BBCOLC)
     C                   EVAL      WBBCOLC = BBCOLC
      **
      ** Access Securities client details file for the field(BFCLAS)
     C                   CALL      'AOSECSR0'
     C**********         PARM      '*DBERR'      @RTCD                                      BUG13608
     C                   PARM      *BLANKS       @RTCD                                      BUG13608
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    DDCSNO
     C     SDSECS        PARM      SDSECS        DSFDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
