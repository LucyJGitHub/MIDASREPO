      *****************************************************************
      *                                                               *
      *  This member is centrally supported and so the source         *
      *  is not available.                                            *
      *                                                               *
      *  Please address any questions to Core Management in London.   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Access Objects                                *
      *                                                               *
      *  GPAOSARDR0 - Global Switchable Features Access Object        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *   Last Amend No. CPK024           Date 13Feb06                *
      *   Prev Amend No. BUG1950          Date 21May04                *
      *                  CGP002 *CREATE   Date 18Sep03                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CPK024 - Packaging for release 1.2.1                         *
      *  BUG1950- Use GPZASNMSG.                                      *
      *  CGP002 - Global Processing Switchability.                    *
      *                                                               *
      *****************************************************************
 
The following code describes the input required by this program:
 
     D P@FMT         E DS                  EXTNAME(DSFDY)
 
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@SARD            6            I:Key field
     C                   PARM                    P@FMT                          O:Format
