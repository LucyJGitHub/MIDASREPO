     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSCOEAPTD - On-Line Update of Global File GZSCOEAPTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. MD046901 *CREATE   Date 21Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046901 - Batch details listview is not loading in the      *
      *             other zone.                                       *
      *                                                               *
      *****************************************************************

     D Z_SCOEAPTD    E DS                  EXTNAME(GZSCOEAPTD) PREFIX(Z_)
     D G_SCOEAPTD    E DS                  EXTNAME(GZSCOEAPTD)
     D Z_OEDATA        S          32000

      ** ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000

      ** Global File Updates

     C     I#BFAF        IFEQ      'B'
     C                   MOVEL     I#BIMG        Z_SCOEAPTD
     C                   ELSE
     C                   MOVEL     I#AIMG        Z_SCOEAPTD
     C                   ENDIF
     C                   MOVEL     I#ZONE        Z_OEZONE

      ** Access record Forecast Total by Nostro Code

     C/exec SQL
     C+ select * into :G_SCOEAPTD from GZSCOEAPTD
     C+ where OETREF = :Z_OETREF AND
     C+ OEZONE = :Z_OEZONE
     C/end-exec

      ** 'Before'

     C     I#BFAF        IFEQ      'B'
     C/EXEC SQL
     C+ DELETE from GZSCOEAPTD
     C+ where OETREF = :Z_OETREF AND
     C+ OEZONE = :Z_OEZONE
     C/END-EXEC
     C                   ELSE

      ** 'After'

     C                   CLEAR                   G_SCOEAPTD
     C                   MOVEL     Z_SCOEAPTD    G_SCOEAPTD
      ** Fix Data
     C                   CALLB     'GPFIXGDTA'
     C                   PARM                    I#ZONE
     C                   PARM      'GZSCOEAPTD'  I#FILE           10
     C                   PARM      G_SCOEAPTD    IO#BUFFER      4000
     C                   MOVEL     IO#BUFFER     G_SCOEAPTD
      ** Update
     C                   IF        SQLCOD = 0
     C/exec SQL
     C+ update GZSCOEAPTD set OEAPIN = :Z_OEAPIN
     C+ , OETREF = :Z_OETREF
     C+ , OEUSRI = :Z_OEUSRI
     C+ , OECODE = :Z_OECODE
     C+ , OETMST = :Z_OETMST
     C+ , OEDATA = :Z_OEDATA
     C+ , OEPDCE = :Z_OEPDCE
     C+ , OEZONE = :Z_OEZONE
     C+ where OETREF = :Z_OETREF AND
     C+ OEZONE = :Z_OEZONE
     C/end-exec
     C                   ELSE
      ** Write
     C/exec SQL
     C+ insert into GZSCOEAPTD
     C+ (
     C+   OEAPIN
     C+ , OETREF
     C+ , OEUSRI
     C+ , OECODE
     C+ , OETMST
     C+ , OEDATA
     C+ , OEPDCE
     C+ , OEZONE
     C+ )
     C+ Values
     C+ (
     C+   :Z_OEAPIN
     C+ , :Z_OETREF
     C+ , :Z_OEUSRI
     C+ , :Z_OECODE
     C+ , :Z_OETMST
     C+ , :Z_OEDATA
     C+ , :Z_OEPDCE
     C+ , :Z_OEZONE
     C+ )
     C/end-exec
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR

     C     W#RUN         IFEQ      *BLANKS

     C                   MOVE      'Y'           W#RUN             1

     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8

     C                   DUMP

      ** If no identified cause of error

     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF

      ** Log an error on the error log

     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000

     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
