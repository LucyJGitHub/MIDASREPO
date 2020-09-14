     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL Initialise DLHISTTD ')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6008 - Initialise Dealing History File                     *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2016            *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *****************************************************************
      *       06         Record not found on DLHISTL0                 *
      *       14         ON if record exists in history file          *
      *       33         END OF FILE FOR DEALSDC                      *
      *****************************************************************
      *
     FDLHISTTD  O    E             DISK
      *
     D ARR@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      ** Local Data Area To Identify Database Errors
      *
      *
     D DEALDC        E DS                  EXTNAME(DEALSDC)
     D  DPCPL        E                     EXTFLD(PCPL)
     D  INTE         E                     EXTFLD(INTR)
     D  DICBS        E                     EXTFLD(ICBS)
     D  DPRIN        E                     EXTFLD(PRIN)
      *
     D DLHIST        E DS                  EXTNAME(DLHISTTD)
     D                                     PREFIX(H)
      *
     I/EJECT
      ********************************************************************
      *                                                                  *
      *     M A I N L I N E                                              *
      *                                                                  *
      ********************************************************************
      *
      **    Initialiseation processing
      *
     C                   Exsr      Init
      *
      **    MAIN PROCESSING
      *
     C                   EXSR      MAIN
      *
      **    END PROCESSING
      *
     C                   SetOn                                            LR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *  INIT    - Initial Processing                                    *
      *                                                                  *
      ********************************************************************
      *
     C     INIT          BEGSR
      *
      ** Initialise Standard variables
      *
     C                   MOVEA     ARR@          BIS@             80
     C                   MOVE      '1'           ON                1
     C                   MOVE      *ZERO         OFF               1
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'MR'          DBPGM
     C                   MOVE      'DLHISTTD'    DBPGM
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *  MAIN    - Main Processing                                       *
      *                                                                  *
      ********************************************************************
      *
     C     MAIN          BEGSR
      *
     C/exec SQL
     C+ declare LiveDl cursor for
     C+ Select * from DEALSDC
     C+  where RECI = 'D'
     C/end-exec

     C/exec SQL
     C+ open LiveDL
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LiveDl
     C+ into :DEALDC
     C/end-exec

     C                   Dow       SQLCod <> 100

     C                   Move      DLNO          TMDLN             6 0
     C                   Z-Add     DPCPL         PRIN             15 0
     C                   Z-Add     0             RBAL             15 0
     C                   Z-Add     0             INTE             11 7
      *
     C     DTYP          Ifeq      'IT'
     C     DTYP          oreq      'CD'
     C     DTYP          oreq      'TD'
     C     DTYP          oreq      'CI'
     C                   Move      'D'           DLFLAG            1
     C                   Else
     C                   Move      'L'           DLFLAG
     C                   Endif
      *
      ** Process History records
      *
     C                   EXSR      FSTREC
      *
      ** If no history records exist, a single record is created
      *
     C     *IN14         Ifeq      '1'
     C                   EXSR      PSOBR
     C                   GOTO      RDNEXT
     C                   Endif
      *
      ** If the first record is an Opening Balance record or a
      ** Lodgement record then no further processing required
      *
     C     RTYP          Ifeq      'LD'
     C                   GOTO      RDNEXT
     C                   Endif
      *
     C     RDNEXT        TAG
     C                   Move      *Off          *IN14

     C/exec SQL
     C+ fetch next
     C+ from LiveDl
     C+ into :DEALDC
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close LiveDL
     C/end-exec
      *
     C                   ENDSR
      *
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  PSOBR    - Set up single Opening Balance record for deals       *
      *             with no history                                      *
      *                                                                  *
      ********************************************************************
      *
     C     PSOBR         BEGSR
      *
     C                   MOVEL     'LD'          RTYP
     C                   Z-ADD     VDAT          EDAT
     C                   Z-ADD     PRIN          PCPL
     C                   Z-ADD     0             NRAT
     C                   Z-ADD     0             ORAT
     C                   MOVE      *BLANKS       TERM
     C                   Z-ADD     1             SQNO
     C                   Z-ADD     PRIN          EAMT
     C                   MOVE      *BLANKS       CHQI
     C                   Z-ADD     DICBS         ICBS
      *
     C                   Write     DLHISTD0
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  FSTREC  - Check record is unique.cords                          *
      *                                                                  *
      ********************************************************************
      *
     C     FSTREC        BEGSR
      *
      ** Check if record already exists in History File
      *
     C                   Z-Add     DLNO          @DLNO             6 0
      *
     C/exec SQL
     C+ select *
     C+ into :DLHIST
     C+ from DLHISTTD
     C+ where DLNO =: @DLNO
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C                   Seton                                            14
     C                   Else
     C/exec SQL
     C+ update DLHISTTD
     C+   set EDAT =: VDAT
     C+ where DLNO =:@DLNO
     C/end-exec
     C                   Endif
      *
     C     FSTR99        ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *  *PSSR   - Error Dump subroutine                                 *
      *                                                                  *
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          Ifeq      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   OUT       LDA
     C                   Endif
      *
     C                   ENDSR
      *
      ********************************************************************
** ARR@   **      OBJECT COPYRIGHT
(C) Copyright Finastra International Limited 2016
