     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate COB Delete')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCBCB   - Validate COB Delete                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 225142             Date 18Feb04               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208730             Date 17Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  225142 - When TOF ICD - Automatic Authorization for Customer *
      *           switched OFF, ensure amends of Private Banking Cust.*
      *           received from TOF are sent directly to Midas repair *
      *           queue as it's done currently for inputs.            *
      *  208730 - Wrong message sent at insert when feature S01424 off*
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
      ** comments
 
      *
      ** VALIDATION
      *
     C                   EXSR      CDELV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCDELOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - COB Delete
      *****************************************************************
     C     CDELV         BEGSR
 
      * If switchable feature, Allow COB deletion is ON
     C     S01424        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB002
     C     DDACTN        ANDEQ     'I'                                          CPB002
     C     BGN4ST        OREQ      'Y'                                          225142
     C     DDACTN        ANDEQ     'A'                                          225142
 
      * COB delete field must have value Y or N
     C     DDCDEL        IFNE      'Y'
     C     DDCDEL        ANDNE     'N'
 
     C     BGN4ST        IFEQ      'Y'                                          CPB002
     C     DDCDEL        ANDEQ     'X'                                          CPB002
     C     DDACTN        ANDEQ     'I'                                          CPB002
     C     BGN4ST        OREQ      'Y'                                          225142
     C     DDCDEL        ANDEQ     'X'                                          225142
     C     DDACTN        ANDEQ     'A'                                          225142
     C     S01424        IFEQ      'Y'                                                        208730
     C                   MOVE      'N'           DDCDEL                         CPB002
     C                   ELSE                                                                 208730
     C                   MOVE      *BLANKS       DDCDEL                                       208730
     C                   END                                                                  208730
     C                   MOVE      'N'           DDCDELOK                       CPB002
     C                   ADD       1             Idx                            CPB002
     C                   MOVEL     'DDCDEL'      FldNamXAr(Idx)                 CPB002
     C                   MOVEL     'USR4592'     MsgIdXAr(Idx)                  CPB002
     C                   ELSE                                                   CPB002
     C     S01424        IFEQ      'Y'                                                        208730
     C                   MOVE      'N'           DDCDELOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCDEL'      FldNamXAr(Idx)
     C                   MOVEL     'USR2236'     MsgIdXAr(Idx)
     C                   ENDIF                                                                208730
     C                   ENDIF                                                  CPB002
     C                   ENDIF
 
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Allow COB Deletion (1A)
      ** S01424 Allow COB Deletion Switchable Feature (1A)
     C                   PARM                    DDCDEL            1
     C                   PARM                    DDACTN            1            CPB002
     C                   PARM                    S01424            1
     C                   PARM                    BGN4ST            1            CPB002
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Allow COB Deletion - OK
     C                   PARM                    DDCDELOK          1
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
(c) Finastra International Limited 2001
