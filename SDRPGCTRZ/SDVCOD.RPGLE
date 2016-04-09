     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate RWA Code & Set Number')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module -                               *
      *          Customer Risk Weighted Assets Details Validation     *
      *                                                               *
      *  SDVCOD - Validate RWA Code & Set Number                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Customer Risk Weighted Assets Details API amendments*
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
      *****************************************************************
      ** Midas SD RWA Code Master file Retrieve
     FSDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CO)
      ** Midas SD RWA Set Master file Retrieve
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S1)
 
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
      ** Array for Combination of Code & Set number
     D CODSET          S              3    DIM(36)
      ** Array for Validated Set number
     D Set_arr         S              1    DIM(36)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Current Code/Set combination string
     D CodSetStr       S              3
      ** Next available position for writing code/set combination array
     D Idx1            S              3P 0
     D Ctr             S              3P 0
 
      ** Next available position for writing code/set combination array
     D DDCOD           S              2A
     D DDSET           S              1A
     D DDCODOK         S              1A
     D DDSETOK         S              1A
 
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
 
      ** Check the RWA code (Exist)
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDCOD         SETLL     SDRWACL1
     C     *IN01         DOWEQ     *OFF
     C     DDCOD         READE     SDRWACL1                               01
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
     C                   IF        CORWCODE = DDCOD AND
     C                             CORWRECI = *BLANK
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      **  Invalid value
     C                   EVAL      DDCODOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOD'
     C                                            + %Trim (%Char (Ctr))
     C                   EVAL      MsgIdXAr(Idx) = 'USR8989'
 
     C                   ENDIF
 
      **  Check the RWA Set Id (exist)
 
     C                   MOVE      *OFF          *IN01
     C                   MOVE      *OFF          *IN02
     C     DDSET         SETLL     SDRWASL1
     C     *IN01         DOWEQ     *OFF
     C     DDSET         READE     SDRWASL1                               01
     C                   IF        *IN01
     C                   ITER
     C                   ENDIF
     C
     C                   IF        *IN01 = *OFF AND
     C                             S1RWRECI = *BLANK
     C                   MOVE      *ON           *IN02
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
      **  Invalid value
     C                   EVAL      DDSETOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSET'
     C                                            + %Trim (%Char (Ctr))
     C                   EVAL      MsgIdXAr(Idx) = 'USR8988'
     C                   ENDIF
 
      ** Check for duplicate RWA Code/Set combination
     C                   EVAL      CodSetStr = DDCOD + DDSET
     C     CodSetStr     LOOKUP    CODSET                                 99
      ** Not found
     C                   IF        *IN99 = *OFF
 
      ** Only 1 RWA code per set allowed for customer
 
     C                   EVAL      Set_Arr = %Subst (CODSET:3:1)
     C     DDSET         LOOKUP    Set_Arr                                98
      ** If Found
     C                   IF        *IN98 = *ON
 
     C                   EVAL      DDSETOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSET'
     C                                            + %Trim (%Char (Ctr))
     C                   EVAL      MsgIdXAr(Idx) = 'USR9381'
 
     C                   ENDIF
      ** Write in Code/Set combination array at next available position
     C                   EVAL      CODSET(Idx1) = DDCOD + DDSET
     C                   EVAL      Idx1 = Idx1 + 1
     C                   ELSE
      ** Error - duplicate Code/Set combination
 
     C                   EVAL      DDCODOK = 'N'
     C                   EVAL      DDSETOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOD'
     C                                            + %Trim (%Char (Ctr))
     C                   EVAL      MsgIdXAr(Idx) = 'USR9382'
 
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
     C                   PARM                    DDCOD
     C                   PARM                    DDSET
     C                   PARM                    CODSET
     C                   PARM                    Idx1
     C                   PARM                    Ctr
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** RWA Code       - OK
     C                   PARM                    DDCODOK
      ** RWA Set number - OK
     C                   PARM                    DDSETOK
 
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
