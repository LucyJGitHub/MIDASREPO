     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate secs depot refs and participants')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVCDRFN - Validate Depot References and Participants        *
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
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 212918             Date 08May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212004             Date 14Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204584             Date 02May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 15Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  212918 - Remove Euroclear reference validation to allow any  *
      *           value to be inserted.                               *
      *  212004 - Depot Reference being right adjusted                *
      *  204584 - Remove USR0268 when CSE022 is switched on.          *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of SD inputs to modular structure        *
      *           to use as APIs                                      *
      *****************************************************************
 
     FSDSECSL0  IF   E           K Disk
 
     FSDSTRDL0  IF   E           K Disk
 
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
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * Second DS for access programs, long data structure
     D*RefArr***       S              6    DIM(10)                                            CSE022
     D RefArr          S             20    DIM(10)                                            CSE022
     D RefFldNam       S             10    DIM(10) CTDATA PERRCD(5)
     D RefOKArr        S              1    DIM(10)
     D ParArr          S              2    DIM(10)
     D ParFldNam       S             10    DIM(10) CTDATA PERRCD(5)
     D ParOKArr        S              1    DIM(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSE022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  204584
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     204584
     D WDepRef         S              6A                                                      CSE022
     D DDDRF1          S              6A                                                      CSE022
     D DDDRF2          S              6A                                                      CSE022
 
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
     C                   MOVEA     *ALL'Y'       RefOKArr
     C                   MOVEA     *ALL'Y'       ParOKArr
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
                                                                                              CSE022
     C                   MOVEL     DDNDR1        DDDRF1                                       CSE022
     C                   MOVEL     DDNDR2        DDDRF2                                       CSE022
 
      *
      ** VALIDATION
      *
     C                   EXSR      VDRFN
      *
      ** If an error was found, set the return code appropriately
      *
     C     'N'           LOOKUP    RefOKArr                               98
     C     'N'           LOOKUP    ParOKArr                               97
     C                   IF        *IN97 = '1' or *IN98 = '1'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
                                                                                              CSE022
     C                   MOVEL     DDDRF1        DDNDR1                                       CSE022
     C                   MOVEL     DDDRF2        DDNDR2                                       CSE022
                                                                                              CSE022
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VDRFN         BEGSR
 
     C                   Z-ADD     0             I                 2 0
 
      ** Set up reference fields array
     C                   Eval      RefArr(1) = DDDRF1
     C                   Eval      RefArr(2) = DDDRF2
     C**********         Eval      RefArr(3) = DDDRF3                                         CSE022
     C                   Eval      RefArr(3) = DDNDR3                                         CSE022
     C**********         Eval      RefArr(4) = DDDRF4                                         CSE022
     C                   Eval      RefArr(4) = DDNDR4                                         CSE022
     C**********         Eval      RefArr(5) = DDDRF5                                         CSE022
     C                   Eval      RefArr(5) = DDNDR5                                         CSE022
     C**********         Eval      RefArr(6) = DDDRF6                                         CSE022
     C                   Eval      RefArr(6) = DDNDR6                                         CSE022
     C**********         Eval      RefArr(7) = DDDRF7                                         CSE022
     C                   Eval      RefArr(7) = DDNDR7                                         CSE022
     C**********         Eval      RefArr(8) = DDDRF8                                         CSE022
     C                   Eval      RefArr(8) = DDNDR8                                         CSE022
     C**********         Eval      RefArr(9) = DDDRF9                                         CSE022
     C                   Eval      RefArr(9) = DDNDR9                                         CSE022
     C**********         Eval      RefArr(10) = DDDRF0                                        CSE022
     C                   Eval      RefArr(10) = DDNDR0                                        CSE022
 
      ** Set up participant fields array
     C                   Eval      ParArr(1) = DDPNP1
     C                   Eval      ParArr(2) = DDPNP2
     C                   Eval      ParArr(3) = DDPNP3
     C                   Eval      ParArr(4) = DDPNP4
     C                   Eval      ParArr(5) = DDPNP5
     C                   Eval      ParArr(6) = DDPNP6
     C                   Eval      ParArr(7) = DDPNP7
     C                   Eval      ParArr(8) = DDPNP8
     C                   Eval      ParArr(9) = DDPNP9
     C                   Eval      ParArr(10) = DDPNP0
 
      ** Get depot values from Securities Trading ICD file
     C     'STRD      '  CHAIN     SDSTRDL0                           99
 
      ** If classification is E
 b1  C                   IF        DDCLAS = 'E'
 
      ** If depot 1 (Euroclear) is not blank
 b2  C                   IF        BVDR1 <> *BLANKS
 
      ** If depot reference 1 is not blank
 b3  C                   IF        DDDRF1 <> *BLANKS
     C                   MOVE      *BLANK        WKDRF1
     C                   MOVE      DDDRF1        WKDRF1
 
      ** Check numeric
     C                   CALL      'ZALIGN'
      *
      ** Return Code (7A)
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** Depot Reference Return Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WKDRF1           16
     C                   PARM      *ZERO         DECIMALS          1 0
     C                   PARM      6             DIGITS            2 0
     C                   PARM      *BLANK        WKDRF1N          16
 
      * If depot reference 1 is not numeric
 b4  C     @RTCD         IFNE      *BLANK
 
      ** Err: 'Value entered must be numeric'
     C                   Eval      RefOKArr(1) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF1    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0822'
 
 x4  C                   ELSE
     C                   CALL      'ZEDIT'
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
     C                   PARM                    WKDRF1N
     C                   PARM      *ZERO         DECIMALS
     C                   Z-ADD     0             WKDR1N            6 0
     C                   MOVE      WKDRF1N       WKDR1N
     C**********         MOVE      *BLANKS       DDDRF1                                       212004
     C**********         MOVE      WKDRF1N       DDDRF1                                       212004
 
      ***If*depot reference 1 is not in ranges 60000-69999 or 90000-99999                     212918
 b5  C**********         IF        not(                                                       212918
     C**********                   (WKDR1N >= 60000 and WKDR1N <= 69999) or                   212918
     C**********                   (WKDR1N >= 90000 and WKDR1N <= 99999))                     212918
      **********                                                                              212918
      ***Err:'Invalid ref. at Euroclear, must be 60000-69999 or 90000-99999'                  212918
     C**********         Eval      RefOKArr(1) = 'N'                                          212918
     C**********         Eval      Idx = Idx + 1                                              212918
     C**********         Eval      FldNamXAr(Idx) = 'DDDRF1    '                              212918
     C**********         Eval      MsgIdXAr(Idx) = 'USR0269'                                  212918
      **********                                                                              212918
 e5  C**********         ENDIF                                                                212918
 
 e4  C                   ENDIF
 
 e3  C                   ENDIF
 
 e2  C                   ENDIF
      ** For depot references 2 - 10
     C     2             DO        10            I
 b2  C                   IF        RefArr(I) <> *BLANKS
 
      ** Err: 'Entry not allowed'
     C                   Eval      RefOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = RefFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR0264'
 e2  C                   ENDIF
     C                   ENDDO
 
 e1  C                   ENDIF
 
      ** If classification is X or M
 b1  C                   IF        DDCLAS = 'X' or DDCLAS = 'M'
 
      ** If depot reference 1 is not blank
 b2  C                   IF        DDDRF1 <> *BLANKS
     C                   MOVE      *BLANK        WKDRF1
     C                   MOVE      DDDRF1        WKDRF1
 
      ** Check numeric
     C                   CALL      'ZALIGN'
      *
      ** Return Code (7A)
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** Depot Reference Return Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WKDRF1           16
     C                   PARM      *ZERO         DECIMALS          1 0
     C                   PARM      6             DIGITS            2 0
     C                   PARM      *BLANK        WKDRF1N          16
 
 
 b3  C     @RTCD         IFNE      *BLANK
 
      ** Err: 'Value entered must be numeric
     C                   Eval      RefOKArr(1) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF1    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0822'
 x3  C                   ELSE
 
     C                   CALL      'ZEDIT'
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
     C                   PARM                    WKDRF1N
     C                   PARM      *ZERO         DECIMALS
     C                   Z-ADD     0             WKDR1N
     C                   MOVE      WKDRF1N       WKDR1N
     C**********         MOVE      *BLANKS       DDDRF1                                       212004
     C**********         MOVE      WKDRF1N       DDDRF1                                       212004
 
      ***Check*entry within valid range                                                       212918
 b4  C**********         IF        not(                                                       212918
     C**********                   (WKDR1N >= 60000 and WKDR1N <= 69999) or                   212918
     C**********                   (WKDR1N >= 90000 and WKDR1N <= 99999))                     212918
      ***Err:*'Invalid ref at Euroclear, must be 60000-69999, 90000-99999'                    212918
     C**********         Eval      RefOKArr(1) = 'N'                                          212918
     C**********         Eval      Idx = Idx + 1                                              212918
     C**********         Eval      FldNamXAr(Idx) = 'DDDRF1    '                              212918
     C**********         Eval      MsgIdXAr(Idx) = 'USR0269'                                  212918
 e4  C**********         ENDIF                                                                212918
 
 e3  C                   ENDIF
 
 e2  C                   ENDIF
 
      ** If depot reference 2 is not blank
 b2  C                   IF        DDDRF2 <> *BLANKS
 
      ** Check numeric
     C                   MOVE      *BLANK        WKDRF2
     C                   MOVE      DDDRF2        WKDRF2
     C                   CALL      'ZALIGN'
      *
      ** Return Code (7A)
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** Depot Reference Return Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WKDRF2           16
     C                   PARM      *ZERO         DECIMALS          1 0
     C                   PARM      6             DIGITS            2 0
     C                   PARM      *BLANK        WKDRF2N          16
 
      * If not numeric
 b3  C     @RTCD         IFNE      *BLANK
 
      ** Err: 'Value entered must be numeric'
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0822'
 x3  C                   ELSE
 
     C                   CALL      'ZEDIT'
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
     C                   PARM                    WKDRF2N
     C                   PARM      *ZERO         DECIMALS
     C                   Z-ADD     0             WKDR2N            6 0
     C                   MOVE      WKDRF2N       WKDR2N
     C**********         MOVE      *BLANKS       DDDRF2                                       212004
     C**********         MOVE      WKDRF2N       DDDRF2                                       212004
 b4  C                   IF        WKDR2N < 1 or WKDR2N > 99999
 
      ** Err: 'Invalid ref at Cedel, must be range 1 - 99999'
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0626'
 e4  C                   ENDIF
 
 e3  C                   ENDIF
 
 e2  C                   ENDIF
 
 e1  C                   ENDIF
 
     C                   IF        CSE022 = 'N'                                               204584
 
      ** If classification is D or I or S
 b1  C                   IF        DDCLAS = 'D' or DDCLAS = 'I' or
     C                             DDCLAS = 'S'
 
      ** If depot reference 1 is not blank
 b2  C                   IF        DDDRF1 <> *BLANKS
 
      ** Get record for this reference on securities details file
     C     DDDRF1        CHAIN     SDSECSL0                           99
 
 b3  C     *IN99         IFEQ      '1'
 
      ** Err: 'Invalid depot reference'
     C                   Eval      RefOKArr(1) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF1    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0268'
 
 x3  C                   ELSE
 
      ** If file classification is not E
 b4  C                   IF        BFCLAS <> 'E'
 
      ** Err: 'Invalid depot reference'
     C                   Eval      RefOKArr(1) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF1    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0268'
 e4  C                   ENDIF
 e3  C                   ENDIF
 e2  C                   ENDIF
 
      ** If depot reference 2 is not blank
 b2  C                   IF        DDDRF2 <> *BLANKS
 
      ** Get record for this reference on securities details file
     C     DDDRF2        CHAIN     SDSECSL0                           99
 
 b3  C     *IN99         IFEQ      '1'
 
 
      ** Err: 'Invalid depot reference'
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0268'
 
 x3  C                   ELSE
 
      ** If file classification is not C
 b4  C                   IF        BFCLAS <> 'C'
 
      ** Err: 'Invalid depot reference
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0268'
 e4  C                   ENDIF
 e3  C                   ENDIF
 e2  C                   ENDIF
     C
 b2  C**********         IF        DDDRF3 <> *BLANKS                                          CSE022
      **********                                                                              CSE022
      ***Get*record*for*this*reference*on*securities*details*file******                       CSE022
     C*****DDDRF3        CHAIN     SDSECSL0                           99                      CSE022
      **********                                                                              CSE022
 b3  C******IN99         IFEQ      '1'                                                        CSE022
      **********                                                                              CSE022
      **********                                                                              CSE022
      ***Err:*'Invalid*depot*reference'********************************                       CSE022
     C**********         Eval      RefOKArr(3) = 'N'                                          CSE022
     C**********         Eval      Idx = Idx + 1                                              CSE022
     C**********         Eval      FldNamXAr(Idx) = 'DDDRF3    '                              CSE022
     C**********         Eval      MsgIdXAr(Idx) = 'USR0268'                                  CSE022
      **********                                                                              CSE022
 x3  C**********         ELSE                                                                 CSE022
      **********                                                                              CSE022
      ***If*file*classification*is*not*K*******************************                       CSE022
 b4  C**********         IF        BFCLAS <> 'K'                                              CSE022
      **********                                                                              CSE022
      ***Err:*'Invalid*depot*reference'********************************                       CSE022
     C**********         Eval      RefOKArr(3) = 'N'                                          CSE022
     C**********         Eval      Idx = Idx + 1                                              CSE022
     C**********         Eval      FldNamXAr(Idx) = 'DDDRF3    '                              CSE022
     C**********         Eval      MsgIdXAr(Idx) = 'USR0268'                                  CSE022
 e4  C**********         ENDIF                                                                CSE022
      **********                                                                              CSE022
 e3  C**********         ENDIF                                                                CSE022
      **********                                                                              CSE022
 e2  C**********         ENDIF                                                                CSE022
 
      ***For*references*4*to*10****************************************                       CSE022
     C*****4             DO        10            I                                            CSE022
                                                                                              CSE022
      ** For references 3 to 10                                                               CSE022
     C     3             DO        10            I                                            CSE022
 
 b2  C                   IF        RefArr(I) <> *BLANKS
 
      ** Get record for this reference on securities details file
     C*****RefArr(I)     CHAIN     SDSECSL0                           99                      CSE022
                                                                                              CSE022
     C                   EVAL      WDepRef = RefArr(I)                                        CSE022
                                                                                              CSE022
     C     WDepRef       CHAIN     SDSECSL0                           99                      CSE022
 
 b3  C     *IN99         IFEQ      '1'
 
 
      ** Err: 'Invalid depot reference'
     C                   Eval      RefOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = RefFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR0268'
 
 x3  C                   ELSE
 
      ** If file classification is not X
 b4  C***********        IF        BFCLAS <> 'X'                                              204584
 b4  C                   IF        BFCLAS = 'X' OR                                            204584
 b4  C                             BFCLAS = 'M'                                               204584
 b4  C                   ELSE                                                                 204584
 
      ** Err: 'Invalid depot reference'
     C                   Eval      RefOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = RefFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR0268'
 e4  C                   ENDIF
 
 e3  C                   ENDIF
 
 e2  C                   ENDIF
 
     C                   ENDDO
 
 e1  C                   ENDIF
 
 e1  C                   ENDIF                                                                204584
 
      ** If classification is C
 b1  C                   IF        DDCLAS = 'C'
 
      ** If depot 2 is not blank and depot reference 2 is blank
 b2  C                   IF        BVDR2 <> *BLANKS and DDDRF2 = *BLANKS
 
      ** Err: 'Value Required'
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0317'
 e2  C                   ENDIF
      ** Check numeric
 b2  C                   IF        DDDRF2 <> *BLANKS
     C                   MOVE      *BLANK        WKDRF2
     C                   MOVE      DDDRF2        WKDRF2
     C                   CALL      'ZALIGN'
      *
      ** Return Code (7A)
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** Depot Reference Return Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WKDRF2           16
     C                   PARM      *ZERO         DECIMALS          1 0
     C                   PARM      6             DIGITS            2 0
     C                   PARM      *BLANK        WKDRF2N          16
 
 b3  C     @RTCD         IFNE      *BLANK
      ** Err: 'Value entered must be numeric'
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0822'
 x3  C                   ELSE
 
     C                   CALL      'ZEDIT'
      ** Depot Reference Message Field (16A)
      ** Number of Decimals (1,0)
     C                   PARM                    WKDRF2N
     C                   PARM      *ZERO         DECIMALS
     C                   Z-ADD     0             WKDR2N
     C                   MOVE      WKDRF2N       WKDR2N
     C**********         MOVE      *BLANKS       DDDRF2                                       212004
     C**********         MOVE      WKDRF2N       DDDRF2                                       212004
 
 b4  C                   IF        WKDR2N < 1 or WKDR2N > 99999
      ** Err: 'Invalid Range at Cedel, must be in range 1 to 99999'
     C                   Eval      RefOKArr(2) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDDRF2    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0626'
 e4  C                   ENDIF
 e3  C                   ENDIF
 e2  C                   ENDIF
 
      ** For depot references 1 to 10 excluding reference 2
     C     1             DO        10            I
 
      ** Skip depot reference 2
 b2  C                   IF        I <> 2
 
      ** If depot reference (I) is not blank
 b3  C                   IF        RefArr(I) <> *BLANKS
 
      ** Err: 'Entry not allowed'
     C                   Eval      RefOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = RefFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR0264'
 e3  C                   ENDIF
 
 e2  C                   ENDIF
 
     C                   ENDDO
 
 e1  C                   ENDIF
 
 
      ***If*classification*is*K****************************************                       CSE022
 b1  C**********         IF        DDCLAS = 'K'                                               CSE022
      **********                                                                              CSE022
      ***For*depot*references*1*-*10*excluding*reference*3*************                       CSE022
     C**********         DO        10            I                                            CSE022
      **********                                                                              CSE022
      ***Skip*depot*reference*3****************************************                       CSE022
 b2  C**********         IF        I <> 3                                                     CSE022
      **********                                                                              CSE022
      ***If*depot*reference*(I)*is*not*blank***************************                       CSE022
 b3  C**********         IF        RefArr(I) <> *BLANKS                                       CSE022
      **********                                                                              CSE022
      ***Err:*'Entry*not*allowed'**************************************                       CSE022
     C**********         Eval      RefOKArr(I) = 'N'                                          CSE022
     C**********         Eval      Idx = Idx + 1                                              CSE022
     C**********         Eval      FldNamXAr(Idx) = RefFldNam(I)                              CSE022
     C**********         Eval      MsgIdXAr(Idx) = 'USR0264'                                  CSE022
 e3  C**********         ENDIF                                                                CSE022
      **********                                                                              CSE022
 e2  C**********         ENDIF                                                                CSE022
      **********                                                                              CSE022
     C**********         ENDDO                                                                CSE022
      **********                                                                              CSE022
      **********                                                                              CSE022
 e1  C**********         ENDIF                                                                CSE022
 
 
 
      ** If classification is X
 b1  C                   IF        DDCLAS = 'X'
 
      ** If participant 1 is 'P'
 b2  C                   IF        DDPNP1 = 'P'
 
      ** Err: 'Participant must be NP'
     C                   Eval      ParOKArr(1) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDPNP1    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0555'
 e2  C                   ENDIF
 
      ***If*reference*3*is*not*blank***********************************                       CSE022
      **********                                                                              CSE022
 b2  C**********         IF        DDDRF3 <> *BLANKS                                          CSE022
     C***Err:*'Entry not allowed'  RefOKArr(3) = 'N'                                          CSE022
     C**********         Eval      RefOKArr(3) = 'N'                                          CSE022
     C**********         Eval      Idx = Idx + 1                                              CSE022
     C**********         Eval      FldNamXAr(Idx) = 'DDDRF3    '                              CSE022
     C**********         Eval      MsgIdXAr(Idx) = 'USR0264'                                  CSE022
 e2  C**********         ENDIF                                                                CSE022
      **********                                                                              CSE022
 e1  C                   ENDIF
 
 
 
      ** If classification is D, I or S
 b1  C                   IF        DDCLAS <> 'D' and DDCLAS <> 'I' and
     C                             DDCLAS <> 'S'
 
     C     1             DO        10            I
 
      ** If depot reference (I) is not blank
 b2  C                   IF        RefArr(I) <> *BLANKS
 
      ** If participant (I) is blank
 b3  C                   IF        ParArr(I) = *BLANKS
 
      ** Err: 'Mandatory entry, if reference allowed'
     C                   Eval      ParOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = ParFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR0273'
 
      ** If <space,P> entered, set to <P,space>
 x3  C                   ELSE
 b4  C                   IF        ParArr(I) = ' P'
     C                   Eval      ParArr(I) = 'P '
 e4  C                   ENDIF
 
      ** If participant is not 'NP' or 'P '
 b4  C                   IF        ParArr(I) <> 'NP' and ParArr(I) <> 'P'
 
      ** Err: 'The value entered for participation is invalid'
     C                   Eval      ParOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = ParFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR1496'
 e4  C                   ENDIF
 
 e3  C                   ENDIF
 
 e2  C                   ENDIF
 
     C                   ENDDO
 
 e1  C                   ENDIF
 
 
 
 
     C     1             DO        10            I
 
      ** If reference is blank and participant is not blank
 b1  C                   IF        RefArr(I) = *BLANKS and
     C                             ParArr(I) <> *BLANKS
 
      ** Err: 'Participant/non-participant not allowed'
     C                   Eval      ParOKArr(I) = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = ParFldNam(I)
     C                   Eval      MsgIdXAr(Idx) = 'USR0301'
 e1  C                   ENDIF
 
     C                   ENDDO
 
 
      ** Pass reference error indicators from array to OK fields
     C**********         Eval      DDDRF1OK = RefOKArr(1)                                     CSE022
     C                   Eval      DDNDR1OK = RefOKArr(1)                                     CSE022
     C**********         Eval      DDDRF2OK = RefOKArr(2)                                     CSE022
     C                   Eval      DDNDR2OK = RefOKArr(2)                                     CSE022
     C**********         Eval      DDDRF3OK = RefOKArr(3)                                     CSE022
     C                   Eval      DDNDR3OK = RefOKArr(3)                                     CSE022
     C**********         Eval      DDDRF4OK = RefOKArr(4)                                     CSE022
     C                   Eval      DDNDR4OK = RefOKArr(4)                                     CSE022
     C**********         Eval      DDDRF5OK = RefOKArr(5)                                     CSE022
     C                   Eval      DDNDR5OK = RefOKArr(5)                                     CSE022
     C**********         Eval      DDDRF6OK = RefOKArr(6)                                     CSE022
     C                   Eval      DDNDR6OK = RefOKArr(6)                                     CSE022
     C**********         Eval      DDDRF7OK = RefOKArr(7)                                     CSE022
     C                   Eval      DDNDR7OK = RefOKArr(7)                                     CSE022
     C**********         Eval      DDDRF8OK = RefOKArr(8)                                     CSE022
     C                   Eval      DDNDR8OK = RefOKArr(8)                                     CSE022
     C**********         Eval      DDDRF9OK = RefOKArr(9)                                     CSE022
     C                   Eval      DDNDR9OK = RefOKArr(9)                                     CSE022
     C**********         Eval      DDDRF0OK = RefOKArr(10)                                    CSE022
     C                   Eval      DDNDR0OK = RefOKArr(10)                                    CSE022
     C
      ** Pass participant error indicators from array to OK fields
     C                   Eval      DDPNP1OK = ParOKArr(1)
     C                   Eval      DDPNP2OK = ParOKArr(2)
     C                   Eval      DDPNP3OK = ParOKArr(3)
     C                   Eval      DDPNP4OK = ParOKArr(4)
     C                   Eval      DDPNP5OK = ParOKArr(5)
     C                   Eval      DDPNP6OK = ParOKArr(6)
     C                   Eval      DDPNP7OK = ParOKArr(7)
     C                   Eval      DDPNP8OK = ParOKArr(8)
     C                   Eval      DDPNP9OK = ParOKArr(9)
     C                   Eval      DDPNP0OK = ParOKArr(10)
 
     C     ENDVAL        ENDSR
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
      ** Customer Number
     C                   PARM                    DDCUST            6
      *
      ** Classification
     C                   PARM                    DDCLAS            1
      *
      ** Depot 1
     C                   PARM                    BVDR1             6
      *
      ** Depot 2
     C                   PARM                    BVDR2             6
      *
      ** Depot Reference 1
     C**********         PARM                    DDDRF1            6                          CSE022
     C                   PARM                    DDNDR1           20                          CSE022
      *
      ** Depot Reference 2
     C**********         PARM                    DDDRF2            6                          CSE022
     C                   PARM                    DDNDR2           20                          CSE022
      *
      ** Depot Reference 3
     C**********         PARM                    DDDRF3            6                          CSE022
     C                   PARM                    DDNDR3           20                          CSE022
      *
      ** Depot Reference 4
     C**********         PARM                    DDDRF4            6                          CSE022
     C                   PARM                    DDNDR4           20                          CSE022
      *
      ** Depot Reference 5
     C**********         PARM                    DDDRF5            6                          CSE022
     C                   PARM                    DDNDR5           20                          CSE022
      *
      ** Depot Reference 6
     C**********         PARM                    DDDRF6            6                          CSE022
     C                   PARM                    DDNDR6           20                          CSE022
      *
      ** Depot Reference 7
     C**********         PARM                    DDDRF7            6                          CSE022
     C                   PARM                    DDNDR7           20                          CSE022
      *
      ** Depot Reference 8
     C**********         PARM                    DDDRF8            6                          CSE022
     C                   PARM                    DDNDR8           20                          CSE022
      *
      ** Depot Reference 9
     C**********         PARM                    DDDRF9            6                          CSE022
     C                   PARM                    DDNDR9           20                          CSE022
      *
      ** Depot Reference 10
     C**********         PARM                    DDDRF0            6                          CSE022
     C                   PARM                    DDNDR0           20                          CSE022
      *
      ** Depot Participant 1
     C                   PARM                    DDPNP1            2
      *
      ** Depot Participant 2
     C                   PARM                    DDPNP2            2
      *
      ** Depot Participant 3
     C                   PARM                    DDPNP3            2
      *
      ** Depot Participant 4
     C                   PARM                    DDPNP4            2
      *
      ** Depot Participant 5
     C                   PARM                    DDPNP5            2
      *
      ** Depot Participant 6
     C                   PARM                    DDPNP6            2
      *
      ** Depot Participant 7
     C                   PARM                    DDPNP7            2
      *
      ** Depot Participant 8
     C                   PARM                    DDPNP8            2
      *
      ** Depot Participant 9
     C                   PARM                    DDPNP9            2
      *
      ** Depot Participant 10
     C                   PARM                    DDPNP0            2
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Depot Reference 1 - OK
     C**********         PARM                    DDDRF1OK          1                          CSE022
     C                   PARM                    DDNDR1OK          1                          CSE022
      ** Depot Reference 2 - OK
     C**********         PARM                    DDDRF2OK          1                          CSE022
     C                   PARM                    DDNDR2OK          1                          CSE022
      ** Depot Reference 3 - OK
     C**********         PARM                    DDDRF3OK          1                          CSE022
     C                   PARM                    DDNDR3OK          1                          CSE022
      ** Depot Reference 4 - OK
     C**********         PARM                    DDDRF4OK          1                          CSE022
     C                   PARM                    DDNDR4OK          1                          CSE022
      ** Depot Reference 5 - OK
     C**********         PARM                    DDDRF5OK          1                          CSE022
     C                   PARM                    DDNDR5OK          1                          CSE022
      ** Depot Reference 6 - OK
     C**********         PARM                    DDDRF6OK          1                          CSE022
     C                   PARM                    DDNDR6OK          1                          CSE022
      ** Depot Reference 7 - OK
     C**********         PARM                    DDDRF7OK          1                          CSE022
     C                   PARM                    DDNDR7OK          1                          CSE022
      ** Depot Reference 8 - OK
     C**********         PARM                    DDDRF8OK          1                          CSE022
     C                   PARM                    DDNDR8OK          1                          CSE022
      ** Depot Reference 9 - OK
     C**********         PARM                    DDDRF9OK          1                          CSE022
     C                   PARM                    DDNDR9OK          1                          CSE022
      ** Depot Reference 10 - OK
     C**********         PARM                    DDDRF0OK          1                          CSE022
     C                   PARM                    DDNDR0OK          1                          CSE022
      ** Depot Participant 1 - OK
     C                   PARM                    DDPNP1OK          1
      ** Depot Participant 2 - OK
     C                   PARM                    DDPNP2OK          1
      ** Depot Participant 3 - OK
     C                   PARM                    DDPNP3OK          1
      ** Depot Participant 4 - OK
     C                   PARM                    DDPNP4OK          1
      ** Depot Participant 5 - OK
     C                   PARM                    DDPNP5OK          1
      ** Depot Participant 6 - OK
     C                   PARM                    DDPNP6OK          1
      ** Depot Participant 7 - OK
     C                   PARM                    DDPNP7OK          1
      ** Depot Participant 8 - OK
     C                   PARM                    DDPNP8OK          1
      ** Depot Participant 9 - OK
     C                   PARM                    DDPNP9OK          1
      ** Depot Participant 10 - OK
     C                   PARM                    DDPNP0OK          1
      *
      ** IS CSE022 ON?                                                                        204584
     C                   CALLB     'AOSARDR0'                                                 204584
     C                   PARM      *BLANKS       @RTCD                                        204584
     C                   PARM      '*VERIFY'     @OPTN                                        204584
     C                   PARM      'CSE022'      @SARD             6                          204584
      *                                                                                       204584
      ** DATABASE ERROR 001                                                                   204584
      *                                                                                       204584
     C     @RTCD         IFNE      *BLANKS                                                    204584
     C     @RTCD         ANDNE     '*NRF   '                                                  204584
     C                   MOVEL     'CSE022'      DBKEY                                        204584
     C                   MOVEL     'SCSARDPD'    DBFILE                                       204584
     C                   MOVEL     '001'         DBASE                                        204584
     C                   EXSR      *PSSR                                                      204584
     C                   END                                                                  204584
     C     @RTCD         IFEQ      *BLANK                                                     204584
     C                   MOVE      'Y'           CSE022            1                          204584
     C                   ELSE                                                                 204584
     C                   MOVE      'N'           CSE022                                       204584
     C                   ENDIF                                                                204584
      *                                                                                       204584
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
**  RefFldNam                                                                                 CSE022
DDDRF1    DDDRF2    DDNDR3    DDNDR4    DDNDR5                                                CSE022
DDNDR6    DDNDR7    DDNDR8    DDNDR9    DDNDR0                                                CSE022
**  ParFldNam
DDPNP1    DDPNP2    DDPNP3    DDPNP4    DDPNP5
DDPNP6    DDPNP7    DDPNP8    DDPNP9    DDPNP0
