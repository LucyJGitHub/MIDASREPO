     H DEBUG
      *****************************************************************
/*XBI *  OVRDBF FILE(UPDLVCB) TOFILE(UPDLVCPD)                        *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Merge two driving files')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0098 - Merge two driving files                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CUP042 *REWRITE    Date 20May15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CUP005 *CREATE     Date 29Oct99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP042 - Simplification of deliverables list.                *
      *  CUP005  -  Changes for DBA R3.02                             *
      *                                                               *
      *****************************************************************
      *
     FUPDLVCB   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(X)
      *
     D BasLib          S             10
     D MrgLib          S             10
     D Update          S              1
     D ErrorMsg        S            100
     D SQLStr          S            450
     D WriteRpt        S              1
     D RptAct          S              7    INZ('*REPORT')
     D RptPgm          S             10    INZ('UP0098')
     D Recursive       S              1
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D DLVC          E DS                  EXTNAME(UPDLVCPD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    BasLib
     C                   PARM                    MrgLib
      *
      * Begin reading the base version of the driving file.
     C     1             SETLL     UPDLVCB
     C                   READ      UPDLVCB
      *
     C                   DOU       %EOF
      *
      ** See if item exists on the merge file.
     C/exec SQL
     C+ select * into :DLVC
     C+ from UPDLVCM
     C+ where
     C+     AUMBNM = :XAUMBNM
     C+ and AUMBTP = :XAUMBTP
     C+ and AUSRCF = :XAUSRCF
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      ** If text does not match then just report.
     C                   IF        AUMBTX <> XAUMBTX
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Text difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If priority does not match then take the lowest value.
     C                   IF        AUIPTY <> XAUIPTY
     C                   IF        AUIPTY < XAUIPTY
     C                   EVAL      XAUIPTY = AUIPTY
     C                   EVAL      Update = 'Y'
     C                   ENDIF
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Priority difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If delivery type does not match then take 'I'.
     C                   IF        AUDTYP <> XAUDTYP
     C                   IF        XAUDTYP <> 'I'
     C                   EVAL      XAUDTYP = 'I'
     C                   EVAL      Update = 'Y'
     C                   ENDIF
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Delivery type difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If copy option  does not match then take the non-blank value (if there
      **  is one).
     C                   IF        AUCPYO <> XAUCPYO
     C                   IF        XAUCPYO = *blank
     C                   EVAL      XAUCPYO = AUCPYO
     C                   EVAL      Update = 'Y'
     C                   ENDIF
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Copy option difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If before / after or special copy does not match then take the
      **  non-blank value (if there is one).
     C                   IF        AUFMTO <> XAUFMTO
     C                   IF        XAUFMTO = *blank
     C                   EVAL      XAUFMTO = AUFMTO
     C                   EVAL      Update = 'Y'
     C                   ENDIF
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Before / after or special copy difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If layer does not match then just report.
     C                   IF        AUDTLB <> XAUDTLB
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Layer'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If object type does not match then just report.
     C                   IF        AUPROJ <> XAUPROJ
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Object type'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If extra information does not match then take the non-blank value (if
      **  there is one).
     C                   IF        AUEXIN <> XAUEXIN
     C                   IF        XAUEXIN = *blank
     C                   EVAL      XAUEXIN = AUEXIN
     C                   EVAL      Update = 'Y'
     C                   ENDIF
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Extra information difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      ** If status does not match then set it to blank.
     C                   IF        AUUSTS <> XAUUSTS
     C                   EVAL      XAUUSTS = *blank
     C                   EVAL      Update = 'Y'
     C                   EVAL      ErrorMsg = AUMBNM + AUMBTP + AUSRCF +
     C                             'Status difference'
     C                   EXSR      WrtRptRec
     C                   ENDIF
      *
      ** If update flag is on then update the base file.
     C                   IF        Update = 'Y'
     C                   UPDATE    UPDLVCD0
     C                   EVAL      Update = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      UPDLVCB
      *
     C                   ENDDO
      *
      ** Insert any non-matching records from the merge library directly into
      **  target library.
     C                   EXSR      InsertRecs
      *
      ** Write report if any records were written.
     C                   IF        WriteRpt = 'Y'
     C                   CALL      'UP008010'
     C                   PARM                    RptAct
     C                   PARM                    RptPgm
     C                   PARM      *blanks       ErrorMsg
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * WrtRptRec - Write record to UPERRMQT.                         *
      *                                                               *
      *****************************************************************
      *
     C     WrtRptRec     BEGSR
      *
     C                   EVAL      WriteRpt = 'Y'
      *
     C/exec SQL
     C+ insert into QTEMP/UPERRMQT
     C+ (
     C+   UPERRMQT
     C+ )
     C+ values (
     C+   :ErrorMsg
     C+ )
     C/end-exec
      *
     C     WrtRptRecE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * InsertRecs - Insert non-matching records.                     *
      *                                                               *
      *****************************************************************
      *
     C     InsertRecs    BEGSR
      *
     C                   EVAL      SQLStr = 'insert into ' + %TRIMR(BasLib) +
     C                             '/UPDLVCPD ( +
     C                               AUMBNM +
     C                             , AUMBTP +
     C                             , AUMBTX +
     C                             , AUCAPR +
     C                             , AUIPTY +
     C                             , AUDTYP +
     C                             , AUCPYO +
     C                             , AUFMTO +
     C                             , AUSRCF +
     C                             , AUDTLB +
     C                             , AUPROJ +
     C                             , AUEXIN +
     C                             , AUUSTS +
     C                             ) select +
     C                               m.AUMBNM +
     C                             , m.AUMBTP +
     C                             , m.AUMBTX +
     C                             , m.AUCAPR +
     C                             , m.AUIPTY +
     C                             , m.AUDTYP +
     C                             , m.AUCPYO +
     C                             , m.AUFMTO +
     C                             , m.AUSRCF +
     C                             , m.AUDTLB +
     C                             , m.AUPROJ +
     C                             , m.AUEXIN +
     C                             , m.AUUSTS +
     C                             from ' + %TRIMR(MrgLib) + '/UPDLVCPD m +
     C                             where not exists (select * from ' +
     C                             %TRIMR(BasLib) + '/UPDLVCPD b where +
     C                                 b.AUMBNM = m.AUMBNM +
     C                             and b.AUMBTP = m.AUMBTP +
     C                             and b.AUSRCF = m.AUSRCF +
     C                             )'
      *
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
      *
     C     InsertRecsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C     PSSRE         ENDSR
      *
      ********************************************************************
