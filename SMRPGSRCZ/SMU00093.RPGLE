     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Facitity History Update Utility')             *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00093 - Facility History Update Utility                   *
      *                                                               *
      *  Function:  This program drops unmatched records on the       *
      *             facility history files compared to the facilities *
      *             file.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 165940  *CREATE    Date 24AUG99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S16594001.                         *
      *  165940  - To drop unmatched records on facility history      *
      *            between FACHISH/FACHISA and FCLTYFM.               *
      *                                                               *
      *****************************************************************
      /EJECT
     FFCLTYL1   IF   E           K DISK
     FFACHISH   UF   E           K DISK
     FFACHISA   UF   E           K DISK
     FSMU004PD  O    E             DISK
     FSMU00093P1O    E             PRINTER OFLIND(*IN65)
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      * 90    READ  fail on FACHISH                                   *
      * 91    CHAIN fail on FCLTYFM                                   *
      * 92    CHAIN fail on FASHISA                                   *
      * 98    Used by Standard Subroutine ZDATE2                      *
      *****************************************************************
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZEDITZ1LE
      *
     D RUNDAT        E DS
     D  MBIN         E                     EXTFLD(AGMBIN)
     D  DATF         E                     EXTFLD(AGDFF)
     D  RUND         E                     EXTFLD(AGRDNB)
     D*
     D                 DS
     D* Datastructure for FACHISA  key
     D  @FAC                   1      5  0
     D  FFTYP                  1      3  0
     D  FFSEQ                  4      5  0
     D*
     D                 DS
     D  OFAM0                  1      7P 0
     D  OFAM1                  1      7P 1
     D  OFAM2                  1      7P 2
     D  OFAM3                  1      7P 3
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Type
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, short data structure
      *
     C     KEY001        KLIST                                                  Key to
     C                   KFLD                    FHBRCH
     C                   KFLD                    FHCNUM
     C                   KFLD                    FHFTYP
     C                   KFLD                    FHFSEQ
     C*
     C     KEY002        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    FHCNUM
     C                   KFLD                    @FAC
     C*
     C                   EXSR      DATE
     C                   WRITE     DELFACH1
     C                   WRITE     DELFACH2
     C                   READ      FACHISH                                90
     C     *IN90         DOWEQ     *OFF
     C   65              WRITE     DELFACH1
     C   65              WRITE     DELFACH2
     C   65              SETOFF                                           65
     C     KEY001        CHAIN     FCLTYL1                            91
     C*
     C*
     C     *IN91         IFEQ      *ON
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FHFCCY        K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C                   MOVE      A6NBDP        DNUM              1 0
     C                   Z-ADD     FHOFAM        OFAM0            13 0
     C                   MOVE      OFAM0         ZFIELD           16
     C                   MOVE      DNUM          ZADEC             1 0
     C                   EXSR      ZEDIT
     C*
     C                   Z-ADD     FHEXDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EXPDAT            7
     C*
     C                   WRITE     SMU004D0
     C                   WRITE     DELFACD1
     C                   DELETE    FACHISHF
     C                   EXSR      FACAMT
     C                   ENDIF
     C*
     C                   READ      FACHISH                                90
     C                   ENDDO
      *
     C                   WRITE     DELFACT1
     C                   MOVE      *OFF          *IN98
     C     DATF          COMP      'M'                                    98
     C                   SETON                                            LR
     C                   RETURN
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/COPY ZSRSRC,ZEDITZ2LE
      ********************************************************************
      *                                                                  *
      *  FACAMT - TO DELETE RECORDS IN FACHISA THAT HAVE NO CORRESPONDING*
      *           RECORDS ON THE FACILITY FILE                           *
      *                                                                  *
      *  CALLED FROM: MAIN PROCESSING                                    *
      *                                                                  *
      *  CALLS: NOTHING                                                  *
      *                                                                  *
      ********************************************************************
     C     FACAMT        BEGSR
     C*
     C                   Z-ADD     FHFTYP        FFTYP
     C                   Z-ADD     FHFSEQ        FFSEQ
     C*
     C     KEY002        CHAIN     FACHISA                            92
     C*
     C     *IN92         DOWEQ     *OFF
     C                   DELETE    FACHISA
     C     KEY002        CHAIN     FACHISA                            92
     C                   ENDDO
     C*
     C                   ENDSR
      ********************************************************************
     C*
     C***  *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS
     C*
     C***  CALLED FROM: AFTER ABNORNAL OPERATION OCCURS
     C*
     C***  CALLS: NOTHING
     C*
      ********************************************************************
      *                                                                  *
      *  DATE   - TO DETERMINE MIDAS SYSTEM DATE.                        *
      *                                                                  *
      *                                                                  *
      *  CALLED FROM: MAIN PROCESSING                                    *
      *                                                                  *
      *  CALLS: NOTHING                                                  *
      *                                                                  *
      ********************************************************************
     C     DATE          BEGSR
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C                   ENDSR
      ********************************************************************
     C*
     C     *PSSR         BEGSR                                                  ** *PSSR **
     C*
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C*
     C                   ENDSR                                                  ** *PSSR **
     C********************************************************************
      /COPY ZSRSRC,ZDATE2Z3
