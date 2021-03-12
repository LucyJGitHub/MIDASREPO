      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420C086 - BALANCE STATEMENTS (A/C FORMATS)                *
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
      */OMITEND                                                                       
      *                                                                               
     C     LUC133        IFEQ      'N'                                                
     C*    ADD POSTING ENTRY TO BALANCE                                               
     C   22                                                                           
     CANN04PSTBAL        SUB       PSTA          PSTBAL               47        
     C   23                                                                           
     CANN04PSTA          ADD       PSTBAL        PSTBAL               47        
      *                                                                               
     C                   ELSE                                                         
     C*    ADD POSTING ENTRY TO BALANCE                                               
     C   22                                                                           
     CANN04PSTBAL        SUB       PSTA          PSTBAL               47        
     C   22                                                                           
     CANN04              Z-ADD     PSTBAL        RUNBAL           15 047        
     C   23                                                                           
     CANN04PSTA          ADD       PSTBAL        PSTBAL               47        
     C   23                                                                           
     CANN04              Z-ADD     PSTBAL        RUNBAL               47        
      *                                                                               
     C     *IN04         IFEQ      *OFF                                               
     C     *IN22         IFEQ      *ON                                                
     C     *IN23         OREQ      *ON                                                
     C     RUNBAL        IFGT      *ZEROS                                             
     C                   MOVE      *ON           *IN09                                
     C                   ELSE                                                         
     C     RUNBAL        IFLT      *ZEROS                                             
     C                   MOVE      *OFF          *IN09                                
     C                   ENDIF                                                        
     C                   ENDIF                                                        
     C                   ENDIF                                                        
     C                   ENDIF                                                        
     C                   ENDIF                                                        
      *
     C     LUC108        IFEQ      'Y'
      *    SET UP AVAILABLE BALANCE FOR HVB STMTS
     C     VALD          IFLE      RUND
     C   22
     CANN04PSTAVL        SUB       PSTA          PSTAVL           15 0
     C   23
     CANN04PSTA          ADD       PSTAVL        PSTAVL
     C                   ENDIF
     C     PSTAVL        COMP      PSTBAL                             4646
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420C086                                       *
      *****************************************************************
