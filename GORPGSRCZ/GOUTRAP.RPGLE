     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Update Global TRAP')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUTRAP - Update Global TRAP                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD032884           Date 09Jun15               *
      *  Prev Amend No. AR1097467A         Date 11Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249207             Date 11Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOTRAPDD and GOWTRAPPD.          *
      *  AR1097467A - Expected 15% COB run optimization not met       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249207 - Records flagged for delete just sitting on GPTRAPPD *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     F***GOWTRAPL0 IP A E           K DISK    RENAME(GOTRAPD0:GOWTRAPD0)                  AR1097467A
     FGOWTRAPL0 IF A E           K DISK    RENAME(GOTRAPD0:GOWTRAPD0)                     AR1097467A
 
     FGOTAPDPD  UF   E             DISK    RENAME( GOTAPDD0 : DRIVERFL )                  AR1097467A
     F                                     USROPN                                         AR1097467A
 
     D/COPY ZACPYSRC,STD_D_SPEC
                                                                                          AR1097467A
      ** Work Variables                                                                   AR1097467A
                                                                                          AR1097467A
     D TaskSplitMode   S               N   INZ                                            AR1097467A
     D PrevCusID       S                   INZ LIKE( T_CNUM )                             AR1097467A
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     I***GOWTRAPD0     01                                                                 AR1097467A
     I**********                                T_CNUM        L1                          AR1097467A
 
 
      ** Check where to start                                                             AR1097467A
                                                                                          AR1097467A
     C                   EVAL      TaskSplitMode = True                                   AR1097467A
     C                   OPEN      GOTAPDPD                                               AR1097467A
     C     1             SETLL     GOTAPDPD                                               AR1097467A
     C                   READ      GOTAPDPD                                               AR1097467A
                                                                                          AR1097467A
     C                   IF        %EOF( GOTAPDPD )                                       AR1097467A
     C                   EVAL      DSCUSD = *LOVAL                                        AR1097467A
     C                   EVAL      DECUSD = *HIVAL                                        AR1097467A
     C                   EVAL      TaskSplitMode = False                                  AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C     DSCUSD        SETLL     GOWTRAPL0                                              AR1097467A
     C                   READ      GOWTRAPL0                                              AR1097467A
                                                                                          AR1097467A
     C                   IF        NOT %EOF( GOWTRAPL0)                                   AR1097467A
     C                   EVAL      PrevCusID = T_CNUM                                     AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   DOW       NOT %EOF( GOWTRAPL0 )                                  AR1097467A
                                                                                          AR1097467A
     C                   IF        T_CNUM > DECUSD                                        AR1097467A
     C                   LEAVE                                                            AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
      ** Commit changes when customer number changes (both modes)                         AR1097467A
      ** Update customer number on the driver file if the record read                     AR1097467A
      ** does not exceed last customer to be processed (Task Split mode)                  AR1097467A
                                                                                          AR1097467A
     C                   IF        T_CNUM > PrevCusID                                     AR1097467A
     C                   EVAL      PrevCusID = T_CNUM                                     AR1097467A
                                                                                          AR1097467A
     C                   IF        TaskSplitMode                                          AR1097467A
     C     1             CHAIN     GOTAPDPD                                               AR1097467A
     C                   EVAL      DSCUSD = PrevCusID                                     AR1097467A
     C                   UPDATE    DRIVERFL                                               AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   COMMIT                                                           AR1097467A
                                                                                          AR1097467A
     C                   ENDIF                                                            AR1097467A
 
      * WRITE TRANSACTION INDEX RECORD
 
     C                   EXSR      WRITE_TRAP
 
     C***L1*****            COMMIT                                                        AR1097467A
     C                   READ      GOWTRAPL0                                              AR1097467A
     C                   ENDDO                                                            AR1097467A
                                                                                          AR1097467A
      ** If there are no errors, commit changes                                           AR1097467A
                                                                                          AR1097467A
     C                   IF        NOT(*INU7 OR *INU8)                                    AR1097467A
     C                   COMMIT                                                           AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   IF        NOT TaskSplitMode                                      AR1097467A
     C                   EVAL      *INLR = *ON                                            AR1097467A
     C                   ENDIF                                                            AR1097467A
                                                                                          AR1097467A
     C                   CLOSE     GOTAPDPD                                               AR1097467A
     C                   RETURN                                                           AR1097467A
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
     C                   MOVEL     'GLOB'        I#LOC
     C                   MOVEL     'N'           I#CUSTDEFLT
     C                   EVAL      T_CCID=0                                                   249207
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
