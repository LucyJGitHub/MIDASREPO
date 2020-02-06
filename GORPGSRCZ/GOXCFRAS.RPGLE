     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for FRAs')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCFRAS - Extract Controller for Forward Rate               *
      *             Agreements                                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Do not extract matured transactions into GPTRAPPD *
      *    Fix was also applied to MP121 via 246296 bug.              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDGF)


     D/COPY ZACPYSRC,STD_D_SPEC


     D FRAS          E DS                  EXTNAME(DEALSDG)


     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL FRAS
      * OR EXTRACT A SINGLE FRA
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL FRAS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      DEALSDGF                               99    *
      *
      * Whilst deals can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      **Extract*any*live*or*matured*FRA*deals*                                              BUG13562
      * Extract any live FRA deals                                                          BUG13562
      *
     C     RECI          IFEQ      'D'
     C*****RECI*         OREQ      'M'                                                      BUG13562
     C     DTYP          IFEQ      'FR'
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   END
     C                   END
      *
      * Read the next record
      *
     C                   READ      DEALSDGF                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE FRA
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#DLNO            6 0
     C     W#DLNO        CHAIN     DEALSDGF                           99        *
      *
      * If the deal is found
      * extract it
      * if not matured                                                                      BUG13562
      *
     C     *IN99         IFEQ      '0'
     C     RECI          ANDNE     'M'                                                      BUG13562
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
     C                   CALLB     'GOXTFRAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0

     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    FRAS

      * If data error encountered, log error

     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'FRAS' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + FRAS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

      * Get Extract control information

      /COPY GOCPYSRC,GOGETEXCT

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
