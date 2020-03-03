     H DEBUG
     H ALWNULL(*USRCTL)                                                                      CER073D
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
**S*D****RPGBASEMOD****************************************************                      CER073D
/*STD *  RPGSQLBND                                                    *                      CER073D
/*EXI *  TEXT('Midas SD CER073 Initialization pgm')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009704 - Midas SD CER073 initialization                    *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CER073D            Date 28Nov19               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073   *CREATE   Date 10Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER073D - Upgrade of EML014 to FB2.1 SP21                    *
      *      EML014 - AnaCredit Reporting Enhancement                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *                                                               *
      *****************************************************************

     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)

     F***SDANACQD  O    E             DISK                                                   CER073D
     FSDANACI0  IF   E           K DISK                                                      CER073D
     FGZANACEI0 IF   E           K DISK                                                      CER073D

      ** =======
      ** D-specs
      ** =======

     D SDANAC        E DS                  EXTNAME(SDANACQD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                 CER073D
     D B_QQDFAC      E                     EXTFLD(QQDFAC)                                    CER073D
     D DSSDY         E DS                  EXTNAME(DSSDY)                                    CER073D

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   CLEAR                   SDANAC

     C     1             SETLL     SDCUSTPD
     C                   READ      SDCUSTPD

     C                   DOW       NOT %EOF(SDCUSTPD)
     C     BBCust        Chain     SDANACI0                           89                     CER073D
     C     *In89         Ifeq      *On                                                       CER073D
     C**********         EVAL      ACCUSN = BBCUST                                           CER073D
     C**********         EVAL      ACBRCD = BBBRCD                                           CER073D
     C/exec SQL                                                                              CER073D
     C+ insert into SDANACQD                                                                 CER073D
     C+ (                                                                                    CER073D
     C+  AcCusn                                                                              CER073D
     C+ ,AcBrcd                                                                              CER073D
     C+ ,AcHoid                                                                              CER073D
     C+ ,AcUpid                                                                              CER073D
     C+ ,AcLegf                                                                              CER073D
     C+ ,AcSolp                                                                              CER073D
     C+ ,AcDtlp                                                                              CER073D
     C+ ,AcEnts                                                                              CER073D
     C+ ,AcDtes                                                                              CER073D
     C+ ,AcNoem                                                                              CER073D
     C+ ,AcBals                                                                              CER073D
     C+ ,AcAntu                                                                              CER073D
     C+ ,AcAstd                                                                              CER073D
     C+ ,AcFnam                                                                              CER073D
     C+ ,AcLNam                                                                              CER073D
     C+ ,AcStrt                                                                              CER073D
     C+ ,AcNumb                                                                              CER073D
     C+ ,AcTown                                                                              CER073D
     C+ ,AcPost                                                                              CER073D
     C+ ,AcRegn                                                                              CER073D
     C+ ,AcCtry                                                                              CER073D
     C+ )                                                                                    CER073D
     C+ Values                                                                               CER073D
     C+ (                                                                                    CER073D
     C+  :BBCust                                                                             CER073D
     C+ ,:BBBrcd                                                                             CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ )                                                                                    CER073D
     C/End-Exec                                                                              CER073D
     C**********         WRITE     SDANACD0                                                  CER073D
     C                   Endif                                                               CER073D
      *                                                                                      CER073D
     C                   Call      'AOBRCHR1'                                                CER073D
     C                   Parm      *BLANKS       @Rtcd             7                         CER073D
     C                   Parm      '*KEY   '     @Optn             7                         CER073D
     C                   Parm      BBBrcd        @Brch             3                         CER073D
     C     SDBrch        Parm      SDBRCH        DSSDY                                       CER073D
      *                                                                                      CER073D
     C     @Rtcd         Ifne      *Blanks                                                   CER073D
     C                   Move      *Blanks       PZone                                       CER073D
     C                   Exsr      *Pssr                                                     CER073D
     C                   else                                                                CER073D
     C                   Move      A8Zone        PZone            10                         CER073D
     C                   Endif                                                               CER073D
                                                                                             CER073D
     C     KANace        Klist                                                               CER073D
     C                   KFld                    BBcust                                      CER073D
     C                   KFld                    PZone                                       CER073D
                                                                                             CER073D
     C     KANace        Chain     GZANACEI0                          89                     CER073D
     C     *In89         Ifeq      *On                                                       CER073D
     C/exec SQL                                                                              CER073D
     C+ insert into T_GZANACEX                                                               CER073D
     C+ (                                                                                    CER073D
     C+  DDCusn                                                                              CER073D
     C+ ,Zone                                                                                CER073D
     C+ ,DDLei                                                                               CER073D
     C+ ,DDNidt                                                                              CER073D
     C+ ,DDNid                                                                               CER073D
     C+ ,DDEuis                                                                              CER073D
     C+ ,DDEuea                                                                              CER073D
     C+ ,DDIpid                                                                              CER073D
     C+ ,DDCptp                                                                              CER073D
     C+ ,DDEcos                                                                              CER073D
     C+ ,DDCpst                                                                              CER073D
     C+ ,DDCpdt                                                                              CER073D
     C+ )                                                                                    CER073D
     C+ Values                                                                               CER073D
     C+ (                                                                                    CER073D
     C+  :BBCust                                                                             CER073D
     C+ ,:PZone                                                                              CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ , Null                                                                               CER073D
     C+ )                                                                                    CER073D
     C/End-Exec                                                                              CER073D
     C                   Endif                                                               CER073D
     C                   READ      SDCUSTPD
     C                   ENDDO


     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
