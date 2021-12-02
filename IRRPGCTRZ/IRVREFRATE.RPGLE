     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate reference rate')
      *****************************************************************
      *                                                               *
      *  Midas - Validate Reference Rate Module                       *
      *                                                               *
      *  IRVREFRATE                                                   *
      *                                                               *
      *  Function:  This module validates a received reference rate.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD059133           Date 10Nov21               *
      *  Prev Amend No. CIR020             Date 02Aug21               *
      *                 CSD103             Date 10Aug20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059133 - Prohibit the user of backward looking rates if    *
      *             CSD103 is switched off                            *
      *  CIR020 - LIBOR Deregulation - FRA/IRS                        *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      * Base rate codes (Keyed by currency code and base rate code)                           CIR020
     FSDBSRTL0  IF   E           K DISK                                                       CIR020
     F                                     INFSR(*pssr)                                       CIR020
                                                                                              CIR020
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                    S01194
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR020

     D** RECORD FORMATS FOR ACCESS TO BASE RATE DETAILS                   S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D** RECORD FORMATS FOR ACCESS TO BASE RATE DETAILS                         CSD006
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CSD006

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#Msgid)

      ** Reference Rate
     D SRFRTE          S              2A

      ** Deal Currency
     D SUCUCY          S              3A

      ** (our) currency
     D SucucyOK        S              1A

      ** Transaction type                                                                     CIR020
     D Transtyp        S              2A                                                      CIR020
                                                                                              CIR020
     D PRtCd           S              7A                                                      CIR020
     D POptn           S              7A                                                      CIR020
     D PSard           S              6A                                                      CIR020
                                                                                              CIR020
      ** Switchable Feature                                                                   CIR020
     D CSD103          S              1A                                                      CIR020
                                                                                              CIR020
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

     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1

     C* Validate Ref Base Rate Code

     C     SRFRTE        IFEQ      *BLANK
     C                   MOVE      'MMA0013'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C*
     C     SRFRTE        IFNE      *BLANK
     C     SUCUCYok      ANDEQ     'Y'
      *
     C** Call Access Program for Base Rate Details
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SUCUCY        @CCY              3
     C                   PARM      SRFRTE        @BBSRT            2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'MMA0014'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C                   MOVEL     BACYCD        SUCUCY
     C                   MOVEL     BABSRC        SRFRTE
     C                   END
     C                   END
      * Key list                                                                              CIR020
     C     BSRTFRA       KLIST                                                                CIR020
     C                   KFLD                    SUCUCY                                       CIR020
     C                   KFLD                    SRFRTE                                       CIR020
                                                                                              CIR020
      ** Check if switchable feature CSD103 is switched on.                                   CIR020
                                                                                              CIR020
     C                   EVAL      CSD103 = 'N'                                               CIR020
                                                                                              CIR020
     C                   CALL      'AOSARDR0'                                                 CIR020
     C                   PARM      *BLANKS       PRtCd                                        CIR020
     C                   PARM      '*VERIFY'     POptn                                        CIR020
     C                   PARM      'CSD103'      PSard                                        CIR020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR020
                                                                                              CIR020
     C                   IF        PRtCd = *BLANKS                                            CIR020
     C                   EVAL      CSD103 = 'Y'                                               CIR020
     C                   ENDIF                                                                CIR020
      *                                                                                       CIR020
      ** Validate the base rate code used in FRA transactions                                 CIR020
      *                                                                                       CIR020
     C     Transtyp      IFEQ      'FR'                                                       CIR020
     C*****CSD103        ANDEQ     'Y'                                                        CIR020
                                                                                     CIR020 MD059133
     C     BSRTFRA       CHAIN     SDBSRTL0                                                   CIR020
     C                   IF        %FOUND(SDBSRTL0)                                           CIR020
     C     BABLRT        IFEQ      'Y'                                                        CIR020
     C                   MOVE      '5049508'     Msgid1                                       CIR020
     C                   MOVE      'Y'           ErrorFound                                   CIR020
     C                   ENDIF                                                                CIR020
     C                   ENDIF                                                                CIR020
                                                                                              CIR020
     C                   ENDIF                                                                CIR020
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    SRFRTE
     C                   PARM                    SUCUCY
     C                   PARM                    SUCUCYok
     C                   PARM                    SDBSRT
     C                   PARM                    Transtyp                                     CIR020

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
