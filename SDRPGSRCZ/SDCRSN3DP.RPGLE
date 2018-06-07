     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS country details')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCRSN3DP - Midas SD CRS country details                     *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL177             Date 11Jan16               *
      *  Prev Amend No. MD038367           Date 22Apr16               *
      *                 MD036200           Date 28Oct15               *
      *                 MD036335           Date 28Oct15               *
      *                 MD036291           Date 26Oct15               *
      *                 MD036274           Date 21Oct15               *
      *                 MD036240           Date 20Oct15               *
      *                 MD036210           Date 19Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD038367 - Database Error occurs when accessing a country    *
      *             located in second page of CRS List of Countries   *
      *  MD036200 - Database error on insert in NAHO                  *
      *  MD036335 - Protect evidence field if CSD093 is off           *
      *  MD036291 - TIN field is not protected                        *
      *  MD036274 - Local TIN validation changes                      *
      *  MD036240 - Non account holder ref is blanks (Recompile)      *
      *  MD036210 - Country cannot be deleted                         *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Midas SD CRS Country Details
     FSDCRSN3DDFCF   E             WORKSTN INFSR(*PSSR)
     F

      ** Table of Field Numbers & Names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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

     D OKCRSCtry     E DS                  EXTNAME(SDECRSNPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            MD036335
      ** External DS for SAR Details                                                        MD036335
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD036335
                                                                                            MD036200
      ** New Non-A/C Holder in Screen Format - Primary Details                              MD036200
     D NewNaPrim     E DS                  Extname(SDNAHLPD)                                MD036200

     D PCrsdS          S            351A   DIM(30)                                            CGL177

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
     D  DDPHNN               220    220
     D  DDRPAY               221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351                                                       CGL177

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D @INKC           S              1
     D @INKJ           S              1
     D @INKL           S              1

     D PRtCd           S              7A
     D POptn           S              7A
     D WOption         S             10A
     D X               S              2S 0
     D Y               S              2S 0
     D PCountry        S              2A
     D PMode           S              1A
     D PDDEVE1         S              2A
     D PDDEVE2         S              2A
     D PDDEVE3         S              2A
     D PDDEVE4         S              2A
     D PDDEVE5         S              2A
     D QRYFLD          S              1A
     D PCust           S             10A
     D PType           S              1A
     D PCode           S              2A
     D PSeqn           S              3A
     D PWarning        S              1A
     D PSard           S              6A                                                    MD036335
     D PPNARN          S             20A                                                    MD036200
     D PPNATW          S             10A                                                    MD036200

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ****************************************************************
      /EJECT
      ****************************************************************
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: *INZSR is  ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+

      ** Main Processing

     C                   EXSR      SRMain

     C     @INKC         IFEQ      *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRMain - Main processing
      *****************************************************************
     C     SRMain        BEGSR

     C                   EVAL      DDREPI = *Zero                                           MD036274
     C                   EVAL      DDNAHL = DDNAHO
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       1971

      ** Set screen error indicator according to status of 'OK' flag.
     C     DDREPQOK      COMP      'N'                                    10
     C     DDREP1OK      COMP      'N'                                    11
     C     DDEVE1OK      COMP      'N'                                    12
     C     DDEVE2OK      COMP      'N'                                    13
     C     DDEVE3OK      COMP      'N'                                    14
     C     DDEVE4OK      COMP      'N'                                    15
     C     DDEVE5OK      COMP      'N'                                    16
     C     DDEFF1OK      COMP      'N'                                    17
     C     DDEXP1OK      COMP      'N'                                    18
     C     DDTINNOK      COMP      'N'                                    19                MD036274

     C                   IF        DDCTRYOK = 'N'
     C                             AND WMsgIdArr(1) = *Blanks
     C                   SETON                                        101112
     C                   SETON                                        131415
     C                   SETON                                        161718
     C                   SETON                                        19
     C                   ENDIF

     C                   EVAL      PWarning = ' '
     C                   IF        WMSGIDARR(1) = 'USS0654'                                 MD036210
     C                   EVAL      PWarning = 'Y'
     C                   EVAL      *IN71 = '1'
     C                   ENDIF

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

     C                   EVAL      X = 1
     C                   EVAL      Y = 1

     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRY = PCountry
     C                   EVAL      Y = X
     C                   EVAL      X = X + 30
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
                                                                                            MD036291
     C                   SETOFF                                       80                    MD036291
     C                   IF        DDCODO = 'Y'                                             MD036291
     C                   SETON                                        80                    MD036291
     C                   ENDIF                                                              MD036291

     C                   SETOFF                                       40
     C                   IF        PMode = 'E'
     C                   SETON                                        4071
     C                   ENDIF

     C                   IF        DDREPM <> *Blanks
     C                   MOVE      DDREPM        DDREPI
     C                   ENDIF

     C                   EVAL      PDDEVE1 = DDEVE1
     C                   EVAL      PDDEVE2 = DDEVE2
     C                   EVAL      PDDEVE3 = DDEVE3
     C                   EVAL      PDDEVE4 = DDEVE4
     C                   EVAL      PDDEVE5 = DDEVE5

     C                   TIME                    DDTIME


     C                   WRITE     SDCRN3M0
     C                   WRITE     SDCRN3D1
     C                   WRITE     SDCRN3F1

     C                   EXFMT     SDCRN3D1

     C                   EVAL      PCrsdS(Y) = PCRSDT

     C                   IF        *INKC = '0'
     C                             AND *INKL = '0'

     C                   IF        PDDEVE1 <> DDEVE1
     C                   EVAL      DDEVS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDEVE2 <> DDEVE2
     C                   EVAL      DDEVS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDEVE3 <> DDEVE3
     C                   EVAL      DDEVS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDEVE4 <> DDEVE4
     C                   EVAL      DDEVS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDEVE5 <> DDEVE5
     C                   EVAL      DDEVS5 = *BLANKS
     C                   ENDIF

     C                   MOVEL     DDEVE1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHO        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
     C                   PARM      DDNARN        PPNARN                                     MD036200
     C                   PARM      DDNATW        PPNATW                                     MD036200

     C                   EVAL      DDEVE1 = PCODE
     C                   MOVE      PSEQN         DDEVS1
     C                   ENDIF

     C                   MOVEL     DDEVE2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHO        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
     C                   PARM      DDNARN        PPNARN                                     MD036200
     C                   PARM      DDNATW        PPNATW                                     MD036200

     C                   EVAL      DDEVE2 = PCODE
     C                   MOVE      PSEQN         DDEVS2
     C                   ENDIF

     C                   MOVEL     DDEVE3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHO        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
     C                   PARM      DDNARN        PPNARN                                     MD036200
     C                   PARM      DDNATW        PPNATW                                     MD036200

     C                   EVAL      DDEVE3 = PCODE
     C                   MOVE      PSEQN         DDEVS3
     C                   ENDIF

     C                   MOVEL     DDEVE4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHO        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
     C                   PARM      DDNARN        PPNARN                                     MD036200
     C                   PARM      DDNATW        PPNATW                                     MD036200

     C                   EVAL      DDEVE4 = PCODE
     C                   MOVE      PSEQN         DDEVS4
     C                   ENDIF

     C                   MOVEL     DDEVE5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHO        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
     C                   PARM      DDNARN        PPNARN                                     MD036200
     C                   PARM      DDNATW        PPNATW                                     MD036200

     C                   EVAL      DDEVE5 = PCODE
     C                   MOVE      PSEQN         DDEVS5
     C                   ENDIF

     C                   ENDIF
      ** Set return keys.

     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   EVAL      PCrsdS(Y) = PCRSDT

     C                   ENDSR

      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2

      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

      ** Entry Parameters

     C     *ENTRY        PLIST

      ** Input Parameters :

      ** Return Code
      ** CRS Country Details - Screen Format
      ** Fields in Error
      ** Errors
      ** Warnings

     C                   PARM                    RetCodeIn
     C                   PARM                    NewNaPrim                                  MD036200
     C                   PARM                    PMode
     C                   PARM                    PCountry
     C                   PARM                    PCrsdS
     C                   PARM                    PWarning
     C                   PARM                    OKCRSCtry
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Output Parameters :

      ** Function Keys

     C                   PARM                    @INKC
     C                   PARM                    @INKJ
     C                   PARM                    @INKL

      ** Initialize program name.

     C                   MOVEL     'SDCRSN3DP'   DBPgm

      ** Move user and workstation ID to screen fields.

     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID

     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           DDPGMQ

      ** Access bank details.

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   MOVEL     '101'         DBase
     C                   MOVEL     POptn         DBKey
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            MD036335
      ** Check if CSD093 is enabled                                                         MD036335
                                                                                            MD036335
     C                   CALL      'AOSARDR0'                                               MD036335
     C                   PARM      *Blanks       PRtcd                                      MD036335
     C                   PARM      '*VERIFY'     POptn                                      MD036335
     C                   PARM      'CSD093'      PSard                                      MD036335
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD036335
                                                                                            MD036335
     C                   EVAL      *IN88 = '1'                                              MD036335
                                                                                            MD036335
     C                   IF        PRtcd = *BLANKS                                          MD036335
     C                   EVAL      *IN88 = '0'                                              MD036335
     C                   ENDIF                                                              MD036335
                                                                                            MD036335

      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY SDCPYSRC,MSGHNDDATA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Finastra International Limited 2015
