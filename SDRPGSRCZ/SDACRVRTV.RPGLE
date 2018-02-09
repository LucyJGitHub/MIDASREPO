     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Detail Retrieve')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDACRVRTV - Account Review Detail Retrieval                  *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD026162A          Date 04Apr14               *
      *                 CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026162A - Serious midas error in account review            *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Account Review file
     FSDACRVL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Account Review file by Front office ID
     FSDACRVL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A)
     F                                     RENAME(SDACRVD0:SDACRVD1)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
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
 
      ** Account Review details in file format
     D CrArFilFmt    E DS                  EXTNAME(SDACRVPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** RUNDAT Data area
     D RUNDAT          DS
     D  MBIN                  13     13
 
     D ZMUSER          DS            17
     D  DBRN                  11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
     D***SDSCDT          S              5P 0                                               MD026162A
     D SDSCDT          S              6A                                                   MD026162A
     D SSCUST          S              6A
     D***SDSEQN          S              3S 0                                               MD026162A
     D SDSEQN          S              3A                                                   MD026162A
     D SSSEQN          S              3S 0                                                 MD026162A
     D WDCOMP          S              1A
     D WCNUM           S             10
     D WCNST           S              7
     D SDACTNok        S              1
     D SDCUSTok        S              1
     D SDSCDTok        S              1                                                    MD026162A
     D SSSCDT          S              5P 0                                                 MD026162A
     D Ix              S              3P 0
     D***PDMODE          S              7                                                  MD026162A
     D PDMODE          S              6                                                    MD026162A
     D RESPMODE        S              1
     D SDACTN          S              1
     D FOTRID          S             20
     D WERR            S              1P 0
     D WZACTN          S              1
     D WZBR            S              3
     D WRTCD           S              7
     D WOPTN           S              7
 
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
      /SPACE 5
      *****************************************************************
 
      ** Clear outputs
 
     C                   CLEAR                   CrARFilFmt
     C                   MOVE      'Y'           SDACTNok
     C                   MOVE      'Y'           SDCUSTok
     C                   MOVE      'Y'           SDSCDTok                                  MD026162A
 
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIdArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      ** If the mode is 'Front office transaction interface'
      ** do validation for front office transaction interface
 
     C                   IF        PDMODE = '*FRONT'
     C                   EXSR      VFRNT
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        SDACTNok = 'N' OR
     C                             SDCUSTok = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Valid action code
 
     C                   EXSR      VALACTN
 
      ** Carry out no further validation if errors occurred.
 
     C                   IF        SDACTNok = 'N'
     C                   RETURN
     C                   ENDIF
 
      **  Validate key fields
 
     C                   EXSR      VLDKEY
 
      **  Carry out no further validation if errors occurred.
 
     C                   IF        SDACTNok = 'N' OR
     C                             SDCUSTok = 'N'
     C                   RETURN
     C                   ENDIF
 
      **  Validate Authority (if not batch download)
 
     C                   IF        PDMODE <> 'B' AND
     C                             RESPMODE = 'S'
     C                   EXSR      VLDAUT
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VFRNT - Validation for front office transaction interface    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     VFRNT         BEGSR
 
      ** Error if action code is not 'I','A' OR 'E'
 
     C                   IF        SDACTN <> 'I' AND
     C                             SDACTN <> 'A' AND
     C                             SDACTN <> 'E'
     C                   MOVEL     'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDOPTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Error if front office transaction ID is blank
 
     C                   IF        FOTRID = *BLANK
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access account review with front office transaction ID
 
     C     FOTRID        CHAIN     SDACRVL2                           99
 
      ** If Insert
 
     C                   IF        SDACTN = 'I'
 
      ** Front office transaction ID can't be present already
 
     C                   IF        *IN99 = '0'
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front office transaction ID must be present
 
     C                   IF        *IN99 = '1'
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** If not insert, update account review
 
     C                   MOVEL     ARCUST        SSCUST
     C                   MOVEL     ARSCDT        SDSCDT
     C                   MOVEL     ARSEQN        SDSEQN
 
     C                   ENDIF
 
     C     EVFRNT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACTN - Validate the action code                           *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     VALACTN       BEGSR
 
     C                   IF        PDMODE = 'B'
 
     C                   IF        SDACTN <> 'I' AND
     C                             SDACTN <> 'A'
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN '     FldNameArr(Ix)
     C                   MOVEL     'USS0382'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        SDACTN <> 'I' AND
     C                             SDACTN <> 'A' AND
     C                             SDACTN <> 'E'
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN '     FldNameArr(Ix)
     C                   MOVEL     'USS0382'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Validate key fields                                          *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : AOCUSTR0                                          *
      *                                                               *
      *****************************************************************
 
     C     VLDKEY        BEGSR
 
     C                   MOVE      *BLANKS       WCNUM
     C                   MOVEL     SSCUST        WCNUM
 
      ** Validate Customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM                    WCNUM
     C                   PARM                    WCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        WRTCD <> *BLANKS
 
     C                   MOVE      'N'           SDCUSTok
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST '     FldNameArr(Ix)
     C                   MOVEL     'LEF0003'     MsgIdArr(Ix)
 
     C                   ELSE
 
     C                   IF        SDACTN <> 'I'
 
      ** Check Screen Date - Run date                                                      MD026162A
                                                                                           MD026162A
     C                   MOVE      SDSCDT        WUWSDT                                    MD026162A
     C                   CALL      'ZDATE1'                             90                 MD026162A
     C     W0RTN         PARM                    W0RTN                                     MD026162A
     C     WUWSDT        PARM                    WUWSDT                                    MD026162A
     C     WUDFF         PARM      BJDFIN        WUDFF                                     MD026162A
     C     WUWFDT        PARM      *ZERO         WUWFDT                                    MD026162A
                                                                                           MD026162A
     C                   IF        *IN90 = *ON                                             MD026162A
                                                                                           MD026162A
     C                   MOVE      'N'           SDSCDTok                                  MD026162A
     C                   ADD       1             Ix                                        MD026162A
     C                   MOVEL     'DDSCDT '     FldNameArr(Ix)                            MD026162A
     C                   MOVEL     'LEF0003'     MsgIdArr(Ix)                              MD026162A
                                                                                           MD026162A
     C                   ENDIF                                                             MD026162A
                                                                                           MD026162A
      ** Return code is an Error                                                           MD026162A
                                                                                           MD026162A
     C                   IF        W0RTN = '*ERROR*'                                       MD026162A
     C                   MOVE      'N'           SDSCDTok                                  MD026162A
     C                   ADD       1             Ix                                        MD026162A
     C                   MOVEL     'DDSCDT '     FldNameArr(Ix)                            MD026162A
     C                   MOVEL     'LEF0003'     MsgIdArr(Ix)                              MD026162A
     C                   ELSE                                                              MD026162A
     C                   EVAL      SSSCDT = WUWFDT                                         MD026162A
     C                   EVALR     SDSEQN = %TRIM(SDSEQN)                                  MD026162A
     C                   MOVE      SDSEQN        SSSEQN                                    MD026162A
                                                                                           MD026162A
      ** Read Account Review
 
     C     KACRV         CHAIN     SDACRVL1                           99
 
      ** If record found...
     C                   IF        *IN99 = *ON
 
     C                   MOVE      'N'           SDCUSTok
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST '     FldNameArr(Ix)
     C                   MOVEL     'LEF0001'     MsgIdArr(Ix)
 
     C                   ENDIF
 
     C                   EVAL      WDCOMP = 'N'
     C                   IF        ARCOMP = 'Y'
     C                   EVAL      WDCOMP = 'Y'
     C                   ENDIF
     C                   EVAL      FOTRID = ARFOID
     C                   ENDIF
     C                   ENDIF                                                             MD026162A
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VLDAUT :   Validate Authority                                *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : ZVACTU, ZVACTBU                                   *
      *                                                               *
      *****************************************************************
 
     C     VLDAUT        BEGSR
 
      **  Validate users authority to use this branch/action
     C                   Z-ADD     *ZERO         WERR
 
      **  If not a multi-branch
     C                   IF        MBIN = 'N'
 
     C                   CALL      'ZVACTU'
     C                   PARM      SDACTN        WZACTN
     C                   PARM                    WERR
 
     C                   IF        WERR <> *ZERO
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0009'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'ZVACTBU'
     C                   PARM      SDACTN        WZACTN
     C                   PARM      DBRN          WZBR
     C                   PARM                    WERR
 
     C**********         MOVE      0             WERR                                      MD026162A
     C                   IF        WERR = 1
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0010'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   IF        WERR = 2
     C                   MOVE      'N'           SDACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN '     FldNameArr(Ix)
     C                   MOVEL     'LEF0011'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Mode
     C                   PARM                    PDMODE
      ** Response mode
     C                   PARM                    RESPMODE
 
      ** Action and customer
     C                   PARM                    SDACTN
     C                   PARM                    SSCUST
     C                   PARM                    SDSCDT
     C                   PARM                    SDSEQN
 
      ** Front Office Transaction ID
     C                   PARM                    FOTRID
     C                   PARM                    WDCOMP
 
      ** OUTPUTS
 
      ** Account Review details format
     C                   PARM                    CrARFilFmt
 
      ** Action and customer OK indicators
     C                   PARM                    SDACTNok
     C                   PARM                    SDCUSTok
     C                   PARM                    SDSCDTok                                  MD026162A
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
 
     C     KACRV         KLIST
     C                   KFLD                    SSCUST
     C**********         KFLD                    SDSCDT                                    MD026162A
     C**********         KFLD                    SDSEQN                                    MD026162A
     C                   KFLD                    SSSCDT                                    MD026162A
     C                   KFLD                    SSSEQN                                    MD026162A
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     WRTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get MBIN from dtaara/RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
