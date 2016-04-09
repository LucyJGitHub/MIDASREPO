     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Account Holder Type Parties')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVACTY  - Validate Account Holder Type Parties              *
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
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
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
 
      ** Customer Base Rate Tax in screen format
     D CuBrt         E DS                  EXTNAME(SDCUBRPD)
 
     D ValidBrt      E DS                  EXTNAME(SDVCUBRPD)
      * Valid Base Rate Tax participant details layout
 
      ** Customer Base Rate Tax in screen format, local to this module
     D CuBrtLoc        DS
     D  DETAI1                 1    138A
     D  DETAI2               139    276A
     D  OTHER2               166    276A
     D  DETAI3               279    416A
     D  OTHER3               306    416A
     D  DETAI4               417    554A
     D  OTHER4               444    554A
     D  DETAI5               555    692A
     D  OTHER5               582    692A
     D  POST5401             693    693A                                                      CRE007
 
     D @DETAILS        S            139    DIM(5)
     D WKXSQN          S              2  0 DIM(5)
 
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
     C                   EXSR      VAHLT
      *
      ** If an error was found, set the return code appropriately
      *
     C     DD1NAMOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VAHLT         BEGSR
      *
      ** Organize participant details in consecutive order
      *
     C                   MOVEA     *ZEROS        WKXSQN
     C                   MOVE      CuBrt         CuBrtLoc
     C                   MOVE      *BLANKS       @DETAILS
     C                   Z-ADD     0             Z                 2 0
     C     DD1NAM        IFNE      *BLANKS
     C                   ADD       1             Z
     C                   MOVE      DETAI1        @DETAILS(Z)
     C     DDACTN        IFEQ      'I'
     C                   EVAL      WKXSQN(Z)=1
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   EVAL      WKXSQN(Z)=BR1SQN
     C                   ENDIF
     C                   END
     C     DD2NAM        IFNE      *BLANKS
     C                   ADD       1             Z
     C                   MOVE      DETAI2        @DETAILS(Z)
     C     DDACTN        IFEQ      'I'
     C                   EVAL      WKXSQN(Z)=2
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   EVAL      WKXSQN(Z)=BR2SQN
     C                   ENDIF
     C                   END
     C     DD3NAM        IFNE      *BLANKS
     C                   ADD       1             Z
     C                   MOVE      DETAI3        @DETAILS(Z)
     C     DDACTN        IFEQ      'I'
     C                   EVAL      WKXSQN(Z)=3
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   EVAL      WKXSQN(Z)=BR3SQN
     C                   ENDIF
     C                   END
     C     DD4NAM        IFNE      *BLANKS
     C                   ADD       1             Z
     C                   MOVE      DETAI4        @DETAILS(Z)
     C     DDACTN        IFEQ      'I'
     C                   EVAL      WKXSQN(Z)=4
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   EVAL      WKXSQN(Z)=BR4SQN
     C                   ENDIF
     C                   END
     C     DD5NAM        IFNE      *BLANKS
     C                   ADD       1             Z
     C                   MOVE      DETAI5        @DETAILS(Z)
     C     DDACTN        IFEQ      'I'
     C                   EVAL      WKXSQN(Z)=5
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   EVAL      WKXSQN(Z)=BR5SQN
     C                   ENDIF
     C                   END
     C                   MOVE      @DETAILS(1)   DETAI1
     C                   MOVE      @DETAILS(2)   DETAI2
     C                   MOVE      @DETAILS(3)   DETAI3
     C                   MOVE      @DETAILS(4)   DETAI4
     C                   MOVE      @DETAILS(5)   DETAI5
     C                   MOVE      CuBrtloc      CuBrt
 
     C                   EVAL      BR1SQN=WKXSQN(1)
     C                   EVAL      BR2SQN=WKXSQN(2)
     C                   EVAL      BR3SQN=WKXSQN(3)
     C                   EVAL      BR4SQN=WKXSQN(4)
     C                   EVAL      BR5SQN=WKXSQN(5)
                                                                                              CRE007
      * Account Holder Type R - 1, 2, 3, 4 or 5 parties must be entered                       CRE007
                                                                                              CRE007
     C     DDAHLT        IFEQ      'R'                                                        CRE007
                                                                                              CRE007
     C     Z             IFEQ      0                                                          CRE007
     C                   MOVE      'N'           DD1NAMOK                                     CRE007
     C                   ADD       1             Idx                                          CRE007
     C                   MOVEL     'DD1NAM'      FldNamXAr(Idx)                               CRE007
     C                   MOVEL     'USR4608'     MsgIdXAr(Idx)                                CRE007
     C                   ENDIF                                                                CRE007
                                                                                              CRE007
     C                   ELSE                                                                 CRE007
 
      * Account Holder Type I - 1, 3, 4 or 5 parties must be entered
 
     C     DDAHLT        IFEQ      'I'
 
     C     Z             IFEQ      0
     C                   MOVE      'N'           DD1NAMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD1NAM'      FldNamXAr(Idx)
     C                   MOVEL     'USR4168'     MsgIdXAr(Idx)
     C                   ENDIF
     C     Z             IFEQ      2
     C                   ADD       1             Idx
     C                   MOVEL     '*any  '      FldNamXAr(Idx)
     C                   MOVEL     'USR4168'     MsgIdXAr(Idx)
     C                   MOVE      'Error'       RetCodeIn
     C                   ENDIF
 
     C                   ELSE
 
      * Account Holder Type J - 2 parties must be entered
 
     C     Z             IFEQ      0
     C                   MOVE      'N'           DD1NAMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DD1NAM'      FldNamXAr(Idx)
     C                   MOVEL     'USR4169'     MsgIdXAr(Idx)
     C                   ELSE
     C     Z             IFNE      2
     C                   ADD       1             Idx
     C                   MOVEL     '*any  '      FldNamXAr(Idx)
     C                   MOVEL     'USR4169'     MsgIdXAr(Idx)
     C                   MOVE      'Error'       RetCodeIn
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                                CRE007
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
     C                   PARM                    CuBrt
     C                   PARM                    DDAHLT            1
     C                   PARM                    DDACTN            1
      *
      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    ValidBrt
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Name 1 - OK
     C                   PARM                    DD1NAMOK          1
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
