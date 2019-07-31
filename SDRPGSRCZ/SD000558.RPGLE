     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Reg Payment Inst Indicia')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000558 - Midas SD Reg Payment Inst Indicia                 *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL177             Date 11Jan16               *
      *  Prev Amend No. CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2 (Recompile)                   *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

     FSDNOSTL2  IF   E           K DISK    INFSR(*PSSR)

     FOTPAYL9   IF   E           K DISK    INFSR(*PSSR)

     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(OP:2)
     F                                     RENAME(@BBREBG:SDCUSTOP)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** CRS Details File Format
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)

      ** CRS Details File Format
     D SDCRSN        E DS                  EXTNAME(SDCRSNPD)

      ** Joint Account File Format
     D SDJACC        E DS                  EXTNAME(SDJACCPD)

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PCountry        S              2A   DIM(30)
     D DDCUST          S              6A
     D DDCTRY          S              2A
     D DDRPAY          S              1A
     D KDCUST          S              6A
     D KDNAHO          S             10A
     D KDCTRY          S              2A
     D WRUN            S              1A
     D WWCSSN          S             10A
     D X               S              2S 0

     D KOTPAYType      S              1A
     D KOTPAYKey35     S             35A
     D KCUST35         S              6A

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      DDRPAY = ' '
     C                   EVAL      X = 1

      ** Check Customer Number
     C                   EVAL      KOTPAYType = 'C'
     C                   EVAL      KOTPAYKey35 = DDCUST
     C     DDCUST        CHAIN     SDCUSTL0
     C                   EVAL      WWCSSN = OPCSSN
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL0
     C                   IF        %FOUND(SDCUSTL0)
     C                   IF        %LOOKUP(OPCOLC:PCountry:1:30) <> 0
     C                   ELSE
     C                   EVAL      PCountry(X) = OPCOLC
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   EVAL      DDRPAY = 'Y'
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

      ** Check Customer Shortname
     C                   EVAL      KOTPAYType = 'S'
     C                   EVAL      KOTPAYKey35 = OPCSSN
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL0
     C                   IF        %FOUND(SDCUSTL0)
     C                   IF        %LOOKUP(OPCOLC:PCountry:1:30) <> 0
     C                   ELSE
     C                   EVAL      PCountry(X) = OPCOLC
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   EVAL      DDRPAY = 'Y'
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

      ** Check Nostros Attached to the customer
     C     DDCUST        SETLL     SDNOSTL2
     C     DDCUST        READE     SDNOSTL2

     C                   DOW       NOT %EOF(SDNOSTL2)
     C                   EVAL      KOTPAYType = 'A'
     C                   EVAL      KOTPAYKey35 = A7CYCD + A7NONB
     C     KOTPAYKey     SETLL     OTPAYL9
     C     KOTPAYKey     READE     OTPAYL9

     C                   DOW       NOT %EOF(OTPAYL9)

     C                   EVAL      KCUST35 = ACB1
     C     KCUST35       CHAIN     SDCUSTL0
     C                   IF        %FOUND(SDCUSTL0)
     C                   IF        %LOOKUP(OPCOLC:PCountry:1:30) <> 0
     C                   ELSE
     C                   EVAL      PCountry(X) = OPCOLC
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   EVAL      DDRPAY = 'Y'
     C                   ENDIF

     C     KOTPAYKey     READE     OTPAYL9
     C                   ENDDO

     C     DDCUST        READE     SDNOSTL2
     C                   ENDDO

     C                   SETON                                        LR
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

     C     *Entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    DDCUST
     C                   PARM                    DDRPAY
     C                   PARM                    PCountry

     C     KOTPAYKey     KLIST
     C                   KFLD                    KOTPAYType
     C                   KFLD                    KOTPAYKey35

      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *Blanks
     C                   EVAL      WRUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

