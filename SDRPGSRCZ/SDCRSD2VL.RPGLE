     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Country Details - Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCRSD2VL - CRS Country Details Validation                   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. CGL177             Date 11Jan16               *
      *                 MD036274           Date 21Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036274 - Local TIN validation changes                      *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS

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

      ** CRS Country Details OK indicators
     D OKCrsD        E DS                  Extname(SDECRSDPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)

      ** External DS for CRS Details
     D SDVCRSD       E DS                  EXTNAME(SDVCRSDPD)

     D ZMUSER          DS            17
     D  USRBCH                11     13

     D PCRSDT          DS
     D  DDCTRY                 1      2
     D  DDPREP                 3      3
     D  DDREPT                 4      4
     D  DDREPU                 5     14
     D  DDREPD                15     20
     D  DDREPM                21     26
     D  DDREP1                27     90
     D  DDREP2                91    154
     D  DDEVD1               155    156
     D  DDEVS1               157    159
     D  DDEVD2               160    161
     D  DDEVS2               162    164
     D  DDEVD3               165    166
     D  DDEVS3               167    169
     D  DDEVD4               170    171
     D  DDEVS4               172    174
     D  DDEVD5               175    176
     D  DDEVS5               177    179
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODO               217    217
     D  DDJACM               218    218
     D  DDMAIL               219    219
     D  DDPHON               220    220
     D  DDRPAY               221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351                                                       CGL177

     D*PCrsdF***       S            217A   DIM(30)                                            CGL177
     D*PCrsdS***       S            350A   DIM(30)                                            CGL177
     D PCrsdF          S            218A   DIM(30)                                            CGL177
     D PCrsdS          S            351A   DIM(30)                                            CGL177
     D PCtry           S              2A   DIM(30)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Retcd           S              7A
     D Option          S              7A
     D DFCTRY          S              2A
     D DFCRSA          S              1A
     D DDCUST          S              6A
     D DDNAHO          S             10A
     D DDCTRYOK        S              1A

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D I               S              3  0
     D PMode           S              1
     D X               S              2S 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Validate Country

     C                   EXSR      SRVCtry

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRVCtry - Validate Country
      *****************************************************************
     C     SRVCtry       BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

     C                   EVAL      PCtry = *Blanks                                          MD036274
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRY <> *Blanks
     C                   EVAL      PCtry(X) = DDCTRY
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO


      ** Validate Country

     C                   CALLB     'SDVCTRY'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    DDCUST
     C                   PARM      *Blanks       DDNAHO
      ** Country
     C                   PARM                    DFCTRY
     C                   PARM                    PCtry

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Country - OK
     C                   PARM                    DDCTRYOK
     C                   PARM                    CVCTRY
     C                   PARM                    DFCRSA

     C                   IF        CVCTRY <> *Blanks
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   IF        PCrsdS(X) = *Blanks
     C                   EVAL      PCrsdS(X) = CVCTRY
     C                   MOVE      DFCRSA        PCrsdS(X)
     C                   EVAL      PCrsdF(X) = CVCTRY
     C                   MOVE      DFCRSA        PCrsdF(X)
     C                   EVAL      X = 31
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   ENDIF

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRResetErrs - Reset error information that is received back  *
      **    from each validation module.                              *
      *****************************************************************
     C     SRResetErrs   BEGSR

     C                   EVAL      RetCodeOut = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRUpdatErrs - Update error information with that received back*
      **    from each validation module.                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF

      ** Set Error Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF

      ** Set Warning Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** INPUTS
      ** Response mode
      ** CRS Country Details

     C                   PARM                    Pmode
     C                   PARM                    DDCUST
     C                   PARM                    DFCTRY
     C                   PARM                    PCrsdS

      ** OUTPUTS
      ** CRS Country Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid CRS Country details layout (DS) from/to caller

     C                   PARM                    OKCrsD
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    PCrsdF

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '001'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
     C                   ENDIF


      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception Errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDCRSD2VL'   Dbpgm
     C                   MOVE      *On           *INU7
     C                   MOVE      *On           *INU8
     C                   MOVE      *On           *INLR

     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2015
