     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate BRT Participant Tax Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVTXIN02- Validate Base Rate Tax BRT Indicator              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP034  *CREATE    Date 22Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE007 - Base Rate Tax 2001                                  *
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
      *
      ** VALIDATION
      *
     C                   EXSR      VXBRT
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDXBRTOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Participant BRT liable flag
      *****************************************************************
     C     VXBRT         BEGSR
 
      * If participant name is entered
     C     DDXNAM        IFNE      *BLANKS
 
      * If the Account Holder Type is 'R' the BRT Liable flag must                            CRE007
      * be either 'N' or 'X'.                                                                 CRE007
     C     DDAHLT        IFEQ      'R'                                                        CRE007
      *                                                                                       CRE007
     C     DDXBRT        IFNE      'N'                                                        CRE007
     C     DDXBRT        ANDNE     'X'                                                        CRE007
     C                   MOVE      'N'           DDXBRTOK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DDXBRT'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4610'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
      *                                                                                       CRE007
     C                   ELSE                                                                 CRE007
      *                                                                                       CRE007
      * Participant BRT liable flag must be Y, N or X
     C     DDXBRT        IFNE      'Y'
     C     DDXBRT        ANDNE     'N'
     C     DDXBRT        ANDNE     'X'
     C                   MOVE      'N'           DDXBRTOK
     C                   ADD       1             Idx
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)
     C                   MOVEL     'USR4155'     MsgIdXAr(Idx)
     C                   ENDIF
                                                                                              CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
     C                   ENDIF
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
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Party BRT Indicator
     C                   PARM                    DDXBRT            1
      *
      ** Party Name
     C                   PARM                    DDXNAM           23
      *                                                                                       CRE007
      ** Account Holder Type                                                                  CRE007
     C                   PARM                    DDAHLT            1                          CRE007
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam         6
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party BRT Indicator - OK
     C                   PARM                    DDXBRTOK          1
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
(c) Misys International Banking Systems Ltd. 2001
