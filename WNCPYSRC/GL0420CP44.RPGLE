      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP44 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Finastra International Banking Systems Ltd. 2016         *
      *                                                               *
      *  Last Amend No. LUC133             Date 01Aug19               *
      *  Prev Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'
      *   HVB PROCESSING - CONVERT TRANSACTION TYPE TO TEXT
     C     TRAT          IFNE      *BLANKS
     C     TRAT          ANDNE     *ZEROS
     C     CHQN          ANDEQ     0
     C     RECI          ANDEQ     'P'
     C     *IN06         ANDEQ     *ON
     C                   CALL      'AORETRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    TRAT
     C     SDRETR        PARM      SDRETR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     888           DBASE                       ****************
     C                   MOVEL     *BLANKS       DBKEY                       * Dbase Err 888*
     C                   MOVEL     TRAT          DBKEY                       ****************
     C                   MOVE      'SDRETRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   GOTO      FINISH
     C                   ENDIF
     C                   MOVE      *BLANKS       DUMY1            20
     C                   MOVE      *BLANKS       DUMY2            30
     C                   MOVE      *BLANKS       DUMY3            10
     C                   MOVEL     A1RTNM        DUMY1
     C*****              MOVE      *BLANKS       DUMY1
     C                   MOVEL     DUMY1         DUMY2
     C     DPMT          IFNE      'FTR'
     C                   MOVEL     PNAR          DUMY3
     C                   ELSE
     C     LUC133        IFEQ      'N'                                                
     C                   MOVE      OTST          DUMY3
     C                   ELSE                                                         
     C                   MOVE      *BLANKS       DUMY3                                
     C                   ENDIF                                                        
     C                   ENDIF
     C                   MOVE      DUMY3         DUMY2
     C     LUC133        IFEQ      'N'                                                
     C                   MOVE      DUMY2         PNAR
     C                   ENDIF                                                        
     C                   ENDIF
     C                   ENDIF
      *
     C     LUC133        IFEQ      'Y'                                                 
      *                                                                                
     C     G2AT          IFEQ      'AT'                                                
     C     G1CY          ANDEQ     '   '                                               
     C                   MOVE      G2CY          G1CY                                  
     C                   MOVE      G2AT          G1AT                                  
     C                   MOVE      G2EX          G1EX                                  
     C                   END                                                           
     C                   MOVEL     GNAR1         PNAR                                  
      *
     C                   ENDIF                                                         
      *
      *****************************************************************
      * End of /COPY GL0420CP44                                       *
      *****************************************************************
